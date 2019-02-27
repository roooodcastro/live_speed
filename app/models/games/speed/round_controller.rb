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
          new(hands: hands, central_pile: central_pile, replacement_piles: replacement_piles)
        end
      end

      def initialize(hands:, central_pile:, replacement_piles:)
        @hands             = hands
        @central_pile      = central_pile
        @replacement_piles = replacement_piles
      end

      # Can only use the replacement piles if there's no possible plays left for both players.
      def can_use_replacement_piles?
        hands.product(central_pile.top_cards).map { |hand, card| hand.possible_play?(card) }.none?
      end

      def mark_player_as_ready(player_id)
        player_hand(player_id).mark_ready_to_play
      end

      def mark_player_replacement_ready(player_id)
        player_hand(player_id).mark_ready_to_play_replacement
      end

      def use_replacement_pile
        return false unless can_use_replacement_piles?

        central_pile.put_initial_cards(pop_replacement_cards)

        # Mark the players as not ready to play replacement, so the next time the replacement piles can be played,
        # they will have to confirm it again.
        hands.each { |hand| hand.mark_ready_to_play_replacement(false) }
      end

      def can_play_card?(player_id, card_index, pile_index)
        card = player_hand(player_id).cards[card_index]
        card.present? && central_pile.can_play?(card, pile_index)
      end

      def play_card(player_id, card_index, pile_index)
        return unless can_play_card?(player_id, card_index, pile_index)

        hand = player_hand(player_id)
        card = hand.cards[card_index]
        central_pile.play_card(hand.remove_card(card_index), pile_index)
        card.to_h
      end

      def finished?
        winner_id.present?
      end

      def unfinished?
        !finished?
      end

      def winner_id
        hands.find { |hand| hand.cards.empty? }&.player&.dig(:id)
      end

      def players_ready?
        hands.map { |hand| hand.player[:ready_to_play] }.all?
      end

      def players_ready_for_replacement?
        hands.map { |hand| hand.player[:ready_replacement] }.all?
      end

      def to_h
        {
          game_name:           'speed',
          hands:               array_to_h(hands),
          replacement_piles:   array_to_h(replacement_piles),
          central_pile:        central_pile.to_h,
          can_use_replacement: can_use_replacement_piles?,
          winner_id:           winner_id
        }
      end

      private

      def player_hand(player_id)
        hands.find { |hand| hand.player[:id] == player_id }
      end

      # Pops and returns 2 replacement cards, one from each pile. If the piles are empty, get all cards from the
      # central piles - except the top cards - and place them in the replacement piles, shuffled.
      def pop_replacement_cards
        refill_replacement_piles if replacement_piles[0].blank?
        [replacement_piles[0].pop, replacement_piles[1].pop]
      end

      def refill_replacement_piles
        new_replacement_cards = central_pile.remove_all_but_top_cards.map(&:shuffle)
        new_replacement_cards.each_with_index { |new_cards, index| replacement_piles[index] += new_cards }
      end
    end
  end
end
