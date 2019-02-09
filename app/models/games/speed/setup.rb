# frozen_string_literal: true

module Games
  module Speed
    class Setup
      attr_reader :players, :rules, :deck, :round_controller

      delegate :to_h, :hands, :replacement_piles, :central_pile, to: :round_controller

      def initialize(players, rules)
        @players = players
        @rules   = rules
        @deck    = Deck.new(size: (players.count / 2.0).ceil)
        create_controller
        deal_cards
      end

      def create_controller
        hands             = players.map { |player| Hand.new(player: { id: player.id, name: player.name }) }
        rep_piles         = Array.new(2) { [] }
        central_pile      = CentralPile.new(rules)
        @round_controller = RoundController.new(hands: hands, replacement_piles: rep_piles, central_pile: central_pile)
      end

      def deal_cards
        hands.each { |hand| hand.deal_cards(deck) }
        replacement_piles.each { |pile| pile.concat deck.draw_cards(amount: 5) }
        central_pile.put_initial_cards(deck.draw_cards(amount: 2))
      end
    end
  end
end
