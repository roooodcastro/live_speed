# frozen_string_literal: true

class Round
  class Setup
    attr_reader :players, :deck, :hands, :replacements, :main_piles

    def initialize(players:)
      @players = players
      create_deck_and_hands
      deal_cards
    end

    def create_deck_and_hands
      num_decks     = (players.count / 2.0).ceil
      @deck         = Deck.new(size: num_decks)
      @hands        = players.map { |player| [player.id, Hand.new(player: player)] }.to_h
      @replacements = Array.new(2) { [] }
      @main_piles   = Array.new(2) { [] }
    end

    def deal_cards
      @hands.values.each do |hand|
        hand.cards = deck.draw_cards(amount: 5)
        hand.draw_pile = deck.draw_cards(amount: 15)
      end
      @replacements.each { |pile| pile.concat deck.draw_cards(amount: 5) }
      @main_piles.each { |pile| pile.concat deck.draw_cards(amount: 1) }
    end

    def to_h
      {
        players: players_to_h,
        deck: deck.to_h,
        replacements: replacements.map { |pile| pile.map(&:to_h) },
        main_piles: main_piles.map { |pile| pile.map(&:to_h) }
      }
    end

    private

    def players_to_h
      players.inject({}) do |players, player|
        players.merge(player.id => { hand: hands[player.id].to_h })
      end
    end
  end
end
