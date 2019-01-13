# frozen_string_literal: true

class Round < ApplicationRecord
  attr_reader :hands

  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :game

  validates :number, presence: true, numericality: true

  delegate :players, to: :game

  def setup_round!
    self.data = Setup.new(players: players).to_h
    save!
  end
end
