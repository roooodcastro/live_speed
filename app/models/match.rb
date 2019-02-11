# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  has_many :rounds, dependent: :destroy
  has_many :match_players, dependent: :destroy
  has_many :players, through: :match_players

  validates :num_rounds, presence: true, numericality: true
  validates :players, length: { in: 1..4 }

  # TODO: Make this configurable, when creating a match, the player can choose the number of opponents
  NUMBER_OF_PLAYERS = 2

  scope :unmatched, lambda {
    joins(:players)
      .group('matches.id')
      .having(Arel.sql("count(players.id) < #{NUMBER_OF_PLAYERS}"))
  }

  def add_player!(player)
    players << player
    save
  end

  def current_round
    return rounds.last if rounds.last&.unfinished?

    create_next_round!
  end

  def create_next_round!
    return rounds.last if rounds.last&.unfinished?

    round_number = rounds.count + 1
    return nil if round_number > num_rounds

    round = rounds.new(number: round_number, data: { game_name: 'speed' })
    round.setup_round!
    round
  end

  def rules
    []
  end
end
