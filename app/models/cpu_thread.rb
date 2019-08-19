# frozen_string_literal: true

class CPUThread
  attr_reader :random, :cpu_players, :next_player_check

  PLAYER_CHECK_INTERVAL = 5.seconds

  def initialize
    @random      = RandomGaussian.new(3, 1)
    @scheduler   = {}
    @cpu_players = {}
    @ticks       = 0
    set_next_player_check
  end

  def run
    Rails.logger.info 'Starting CPU Thread...'

    loop do
      tick = Time.current.to_f

      find_dangling_cpu_players if tick >= next_player_check
      process_moves(tick)

      sleep 0.01
    end
  ensure
    Rails.logger.info 'Exiting CPU Thread, disconnecting all CPU players...'
    disconnect_all_cpu_players!
  end

  private

  # Sleeps for a random amount of time, never less than 1s, never more than 7s.
  # The exact amount follows the normal/gaussian distribution.
  def next_move_time
    delay = random.rand.clamp(1, 7)
    Time.current.to_f + delay
  end

  def set_next_player_check
    @next_player_check = Time.current.to_f + PLAYER_CHECK_INTERVAL
  end

  # Returns CPU players that are not in this pool and are part of a Round that's
  # currently playing or waiting to be played.
  def find_dangling_cpu_players
    players = Player::CPU
              .joins(:matches)
              .where(matches: { id: Round.created_or_playing.with_cpu_players.pluck(:match_id) })
              .where.not(id: cpu_players.keys)
    players.each(&method(:activate_player))

    log("Found #{players.count} dangling CPU players")

    set_next_player_check
  end

  def activate_player(player)
    # A CPU player will only ever play a single game and be discarded afterwards (sorry, CPU)
    round = player.matches.first.current_round(false)
    cpu_players[player.id] = { player: player, round: round, next_move_time: next_move_time }
    log("Add #{player.name} to pool, on round #{round&.id || '<no round>'}")
    return unless round

    player.play!(round)
  end

  def disconnect_all_cpu_players!
    cpu_players.values.each do |cpu_player|
      cpu_player[:round].mark_player_connected(cpu_player[:player].id, false)
    end
  end

  def process_moves(tick)
    cpu_players.values.each do |player_hash|
      next if player_hash[:next_move_time] > tick

      player = player_hash[:player]
      round = player_hash[:round]
      next remove_cpu(player) unless round&.unfinished?

      player.play!(round)
      player_hash[:next_move_time] = next_move_time
    end
  end

  def remove_cpu(player)
    log("Removing #{player.name} from pool, no rounds active")
    cpu_players.delete(player.id)
  end

  def log(message)
    Rails.logger.info(Rainbow("[CPU] #{message}").green.bright)
  end
end
