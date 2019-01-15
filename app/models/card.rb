# frozen_string_literal: true

class Card
  attr_reader :suit, :rank

  include Comparable

  SUITS = %i[c d h s].freeze
  RANKS = %i[a 2 3 4 5 6 7 8 9 10 j q k].freeze

  USE_UNICODE = true

  def self.number_to_rank(number)
    number = ((number - 1) % 13) + 1
    ({ 1 => :a, 11 => :j, 12 => :q, 13 => :k }[number] || number).to_s.to_sym
  end

  def self.from_h(hash)
    new(suit: hash[:s].to_sym, rank: hash[:r].to_sym)
  end

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

  def to_i
    { a: 1, j: 11, q: 12, k: 13 }[rank] || rank.to_s.to_i
  end

  def <=>(other)
    return 1 if rank == :a && other.rank == :k
    return -1 if rank == :k && other.rank == :a

    to_i <=> other.to_i
  end

  def ==(other)
    return false if suit != other.suit

    to_i == other.to_i
  end

  def prev
    next_rank = self.class.number_to_rank(to_i - 1)
    self.class.new(suit: suit, rank: next_rank)
  end

  def next
    next_rank = self.class.number_to_rank(to_i + 1)
    self.class.new(suit: suit, rank: next_rank)
  end
  alias succ next

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
