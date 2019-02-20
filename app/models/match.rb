# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  has_many :rounds, dependent: :destroy
  has_many :match_players, dependent: :destroy
  has_many :players, through: :match_players, inverse_of: :matches

  validates :num_rounds, presence: true, numericality: true
  validates :num_players, numericality: { between: 2..4 }
  validates :match_players, length: { in: 1..4 }

  scope :from_player, ->(player_id) { joins(:match_players).where match_players: { player_id: player_id } }

  scope :unmatched, lambda {
    joins(:players)
      .group('matches.id')
      .having(Arel.sql('count(players.id) < num_players'))
  }

  def add_player!(player)
    players << player
  end

  def current_round
    rounds.last
    # return rounds.last if rounds.last&.unfinished?

    # create_next_round!
  end

  def create_next_round!
    return rounds.last if rounds.last&.unfinished?

    round_number = rounds.count + 1
    return nil if round_number > num_rounds

    round = rounds.new(number: round_number, data: { game_name: 'speed' })
    round.setup_round!
    round
  end

  def winner_id
    round_winners = rounds.pluck(:winner_id)
                          .group_by(&:itself)
                          .transform_values(&:size)
                          .except(nil)
    most_round_wins = round_winners.max_by(&:last)
    return unless most_round_wins # If no one has won a round yet

    most_round_wins.first if most_round_wins.last > num_rounds / 2
  end

  def winner
    players.find_by(id: winner_id)
  end

  def can_play?
    match_players.size == num_players && !winner_id
  end

  def description
    "Best of #{num_rounds} rounds, #{players.size}/#{num_players} players"
  end

  def rules
    []
  end
end
