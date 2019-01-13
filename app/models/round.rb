# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :game

  validates :number, presence: true, numericality: true

  delegate :players, :rules, to: :game

  def setup_round!
    self.data = Setup.new(players, rules).to_h
    save!
  end

  def play_card!(player_id:, card_index:, pile_index:)
    card = player_hands[player_id].cards[card_index]
    central_pile.play_card(card, pile_index)
  end

  def player_hands
    data['hands']
  end

  def central_pile
    @central_pile ||= CentralPile.from_h(data['central_pile'].deep_symbolize_keys, [])
  end
end
