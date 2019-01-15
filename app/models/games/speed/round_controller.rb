# frozen_string_literal: true

module Games
  module Speed
    class RoundController < ::Games::Controller
      attr_reader :hands, :central_pile, :replacement_piles

      class << self
        def from_h(hash)
          central_pile      = Speed::CentralPile.from_h(hash[:central_pile], [])
          hands             = array_from_h(hash[:hands], Speed::Hand)
          replacement_piles = array_from_h(hash[:replacement_piles], Speed::Card)
          self.new(hands: hands, central_pile: central_pile, replacement_piles: replacement_piles)
        end
      end

      def initialize(hands:, central_pile:, replacement_piles:)
        @hands             = hands
        @central_pile      = central_pile
        @replacement_piles = replacement_piles
      end

      # Can only use the replacement piles if there's no possible plays left for both players.
      def can_use_replacement_piles?
        no_plays = hands.product(central_pile.top_cards).map { |hand, card| hand.possible_play?(card) }.none?
        no_plays && replacement_piles[0].present?
      end

      def use_replacement_pile!
        raise InvalidPlayError, 'Cannot use replacement pile!' unless can_use_replacement_piles?
        central_pile.put_initial_cards([replacement_piles[0].pop, replacement_piles[1].pop])
      end

      def can_play_card?(player_id, card_index, pile_index)
        card = player_hand(player_id).cards[card_index]
        card.present? && central_pile.can_play?(card, pile_index)
      end

      def play_card!(player_id, card_index, pile_index)
        raise InvalidPlayError unless can_play_card?(player_id, card_index, pile_index)

        hand = player_hand(player_id)
        central_pile.play_card(hand.remove_card(card_index), pile_index)
      end

      # Temporary method to print relevant round info so I can play on the terminal
      def print_game # rubocop:disable Metrics/AbcSize
        hand1 = player_hand(1)
        hand2 = player_hand(2)
        Rails.logger.info "\nHand 1: #{hand1.cards.join(' ')}, #{hand1.draw_pile.size} extra"
        Rails.logger.info "Hand 2: #{hand2.cards.join(' ')}, #{hand2.draw_pile.size} extra"
        Rails.logger.info "\nPiles: #{central_pile.piles.map(&:last)}"
      end

      def finished?
        winner.present?
      end

      def unfinished?
        !finished?
      end

      def winner
        hands.each do |hand|
          next if hand.cards.present?

          return hand.player
        end
        nil
      end

      def to_h
        {
          game_name:         'speed',
          hands:             array_to_h(hands),
          replacement_piles: array_to_h(replacement_piles),
          central_pile:      central_pile.to_h
        }
      end

      private

      def player_hand(player_id)
        hands.find { |hand| hand.player_id == player_id.to_i }
      end
    end
  end
end
