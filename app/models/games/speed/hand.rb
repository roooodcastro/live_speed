# frozen_string_literal: true

module Games
  module Speed
    class Hand
      attr_accessor :cards, :draw_pile
      attr_reader :player

      def self.from_h(hash)
        cards       = hash[:cards].map { |card| Card.from_h(card) }
        draw_pile   = hash[:draw_pile].map { |card| Card.from_h(card) }
        player_data = hash[:player]
        Hand.new(player: player_data, cards: cards, draw_pile: draw_pile)
      end

      def initialize(player:, cards: nil, draw_pile: nil)
        @player    = player
        @cards     = cards || []
        @draw_pile = draw_pile || []
      end

      def deal_cards(deck)
        @cards     = deck.draw_cards(amount: 5)
        @draw_pile = deck.draw_cards(amount: 15)
      end

      def mark_ready_to_play
        player[:ready] = true
      end

      def mark_ready_to_play_replacement(ready = true)
        player[:ready_replacement] = ready
      end

      def remove_card(index)
        raise "Player #{player[:name]} has no cards left to play!" if cards.empty?
        return cards.delete_at(index) if draw_pile.empty?

        card         = cards[index]
        cards[index] = draw_pile.pop
        card
      end

      def possible_plays(pile_cards)
        cards.each_with_index.map do |card, card_index|
          target_piles = pile_cards.each_with_index.map { |pile_card, index| index if pile_card.can_play?(card) }
          next if target_piles.compact.empty?

          [card_index, target_piles.compact]
        end.compact.to_h
      end

      def possible_play?(pile_card)
        cards.map { |player_card| pile_card.can_play?(player_card) }.any?
      end

      def to_h
        { cards: cards.map(&:to_h), draw_pile: draw_pile.map(&:to_h), player: player }
      end
    end
  end
end
