# frozen_string_literal: true

module Speed
  class Setup
    attr_reader :players, :rules, :deck, :round_controller

    delegate :to_h, to: :round_controller

    def initialize(players, rules)
      @players = players
      @rules = rules
      create_objects
      deal_cards
    end

    def create_objects
      num_decks         = (players.count / 2.0).ceil
      hands             = players.map { |player| Hand.new(player: player) }
      rep_piles         = Array.new(2) { [] }
      central_pile      = CentralPile.new(rules)
      @round_controller = RoundController.new(hands: hands, replacement_piles: rep_piles, central_pile: central_pile)
      @deck             = Deck.new(size: num_decks)
    end

    def deal_cards
      round_controller.hands.each do |hand|
        hand.cards = deck.draw_cards(amount: 5)
        hand.draw_pile = deck.draw_cards(amount: 15)
      end
      round_controller.replacement_piles.each { |pile| pile.concat deck.draw_cards(amount: 5) }
      round_controller.central_pile.put_initial_cards(deck.draw_cards(amount: 2))
    end
  end
end
