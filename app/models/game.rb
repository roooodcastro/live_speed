# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  has_many :rounds, dependent: :destroy
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players

  validates :num_rounds, presence: true, numericality: true
  validates :players, length: { in: 2..4 }

  def current_round
    return rounds.last if rounds.present?

    create_next_round!
  end

  def create_next_round!
    round_number = rounds.count + 1
    return nil if round_number >= num_rounds

    round = rounds.create(number: round_number)
    round.setup_round!
  end
end
