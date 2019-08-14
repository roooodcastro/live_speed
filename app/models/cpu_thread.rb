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
    loop do
      tick = Time.current.to_f

      find_dangling_cpu_players if tick >= next_player_check
      process_moves(tick)

      sleep 0.01
    end
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

    set_next_player_check
  end

  def activate_player(player)
    round = player.matches.first.current_round

    cpu_players[player.id] = { player: player, round: round, next_move_time: next_move_time }
  end

  def process_moves(tick)
    cpu_players.values.each do |player_hash|
      next if player_hash[:next_move_time] > tick

      if player_hash[:round].finished?
        cpu_players.delete(player_hash[:player].id)
      else
        player_hash[:player].play!(player_hash[:round])
        player_hash[:next_move_time] = next_move_time
      end
    end
  end
end
