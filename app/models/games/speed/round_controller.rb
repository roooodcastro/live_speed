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
        no_plays = hands.product(central_pile.top_cards).map { |hand, card| hand.possible_play?(card) }.none?
        no_plays && replacement_piles[0].present?
      end

      def mark_player_as_ready(player_id)
        player_hand(player_id).mark_ready_to_play
      end

      def mark_player_replacement_ready(player_id)
        player_hand(player_id).mark_ready_to_play_replacement
      end

      def use_replacement_pile
        return false unless can_use_replacement_piles?

        central_pile.put_initial_cards([replacement_piles[0].pop, replacement_piles[1].pop])

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

      # Temporary method to print relevant round info so I can play on the terminal
      def print_game
        hands.each_with_index do |hand, index|
          Rails.logger.info "Hand #{index}: #{hand.cards.join(' ')}, #{hand.draw_pile.size} extra"
        end

        Rails.logger.info "\nPiles: #{central_pile.piles.map(&:last)}"
      end

      def finished?
        winner.present?
      end

      def unfinished?
        !finished?
      end

      def winner
        hands.find { |hand| hand.cards.empty? }
      end

      def players_ready?
        hands.map { |hand| hand.player[:ready] }.all?
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
          can_use_replacement: can_use_replacement_piles?
        }
      end

      private

      def player_hand(player_id)
        hands.find { |hand| hand.player[:id] == player_id }
      end
    end
  end
end
