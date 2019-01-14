# frozen_string_literal: true

class Hand
  attr_accessor :player, :cards, :draw_pile

  delegate :id, to: :player, prefix: true

  def self.from_h(hash)
    cards = hash[:cards].map { |card| Card.from_h(card) }
    draw_pile = hash[:draw_pile].map { |card| Card.from_h(card) }
    Hand.new(player: hash[:player], cards: cards, draw_pile: draw_pile)
  end

  def initialize(player:, cards: nil, draw_pile: nil)
    @player    = player
    @cards     = cards || []
    @draw_pile = draw_pile || []
  end

  def remove_card(index)
    raise "Player #{player.name} has no cards left to play!" if cards.empty?
    return cards.delete_at(index) if draw_pile.empty?

    card = cards[index]
    cards[index] = draw_pile.pop
    card
  end

  def possible_play?(pile_card)
    cards.map { |player_card| pile_card.can_play?(player_card) }.any?
  end

  def to_h
    { cards: cards.map(&:to_h), draw_pile: draw_pile.map(&:to_h), player_id: player.id }
  end
end
