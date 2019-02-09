# frozen_string_literal: true

module Games
  module Speed
    class CentralPile
      attr_reader :piles, :rules

      def self.from_h(hash, rules)
        piles        = hash[:piles].map { |pile| pile.map { |card_hash| Speed::Card.from_h(card_hash) } }
        central_pile = Speed::CentralPile.new(rules, piles: piles)
        central_pile
      end

      def initialize(rules, piles: nil)
        @piles = piles || Array.new(2) { [] }
        @rules = rules
      end

      def put_initial_cards(cards)
        raise "Exactly 2 cards, not #{cards.size}, are required to setup the central piles." unless cards.size == 2

        @piles[0] << Speed::Card.from_h(cards.first.to_h)
        @piles[1] << Speed::Card.from_h(cards.last.to_h)
      end

      def play_card(card, pile_index)
        raise StandardError, "#{card} cannot be played now!" unless can_play?(card, pile_index)

        piles[pile_index] << card
      end

      def can_play?(card, pile_index)
        top_card = piles[pile_index].last
        top_card.can_play?(card)
      end

      def top_cards
        piles.map(&:last)
      end

      def to_h
        {
          piles: [
            piles[0].map(&:to_h),
            piles[1].map(&:to_h)
          ]
        }
      end
    end
  end
end
