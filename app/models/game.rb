# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  has_many :rounds, dependent: :destroy
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players

  validates :num_rounds, presence: true, numericality: true
  validates :players, length: { in: 2..4 }

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
  end

  def rules
    []
  end
end
