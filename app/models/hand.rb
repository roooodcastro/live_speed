# frozen_string_literal: true

class Hand
  attr_accessor :player, :cards, :draw_pile

  def initialize(player:)
    @player = player
    @cards, @draw_pile = []
  end

  def to_h
    { cards: cards.map(&:to_h), draw_pile: draw_pile.map(&:to_h), player_id: player.id }
  end
end
