# frozen_string_literal: true

class Deck
  attr_reader :cards

  def initialize(size: 1)
    fixed_size = [size, 1].max # Avoids zero or negative sizes
    @cards = build_cards * fixed_size
  end

  # Removes and returns +amount+ of cards from the deck, in a random order.
  def draw_cards(amount: 1)
    Array.new(amount).map { cards.delete_at(rand(cards.size)) }
  end

  def to_h
    { cards: cards.map(&:to_h) }
  end

  private

  def build_cards
    Card::SUITS.product(Card::RANKS).map { |suit, rank| Card.new(suit: suit, rank: rank) }
  end
end
