# frozen_string_literal: true

class Card
  attr_reader :suit, :rank

  SUITS = %i[c d h s].freeze
  RANKS = %i[a 2 3 4 5 6 7 8 9 10 j q k].freeze

  USE_UNICODE = true

  def initialize(suit: nil, rank: nil)
    @suit = suit || SUITS.sample
    @rank = rank || RANKS.sample
    validate_card
  end

  def to_s
    return to_unicode if USE_UNICODE

    "#{full_rank_name} of #{full_suit_name}"
  end
  alias inspect to_s

  def to_unicode
    suit_code = { c: 0xD0, d: 0xC0, h: 0xB0, s: 0xA0 }[suit]
    rank_code = { a: 1, '10': 0xA, j: 0xB, q: 0xD, k: 0xE }[rank] || rank.to_s.to_i
    code = 0x1F000 + suit_code + rank_code
    code.chr
  end

  def to_h
    { s: suit, r: rank }
  end

  private

  def validate_card
    raise ArgumentError, "Suit '#{suit}' does not exist" unless SUITS.include?(suit.to_s.to_sym)
    raise ArgumentError, "Rank '#{rank}' does not exist" unless RANKS.include?(rank.to_s.to_sym)
  end

  def full_rank_name
    { a: 'Ace', j: 'Jack', q: 'Queen', k: 'King' }[rank] || rank.to_s
  end

  def full_suit_name
    { c: 'clubs', d: 'diamonds', h: 'hearts', s: 'spades' }[suit]
  end
end
