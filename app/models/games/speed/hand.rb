# frozen_string_literal: true

module Games
  module Speed
    class Hand
      attr_accessor :cards, :draw_pile
      attr_reader :player

      delegate :id, to: :player, prefix: true

      def self.from_h(hash)
        cards       = hash[:cards].map { |card| Card.from_h(card) }
        draw_pile   = hash[:draw_pile].map { |card| Card.from_h(card) }
        player_data = hash[:players].to_a.find { |player| player.id == hash[:player_id] }
        Hand.new(player: player_data, cards: cards, draw_pile: draw_pile)
      end

      def initialize(player:, cards: nil, draw_pile: nil)
        @player    = player
        @cards     = cards || []
        @draw_pile = draw_pile || []
      end

      def player=(players)
        @player = players.to_a.find { |player| player.id == player_id }
      end

      def remove_card(index)
        raise "Player #{player.name} has no cards left to play!" if cards.empty?
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
        { cards: cards.map(&:to_h), draw_pile: draw_pile.map(&:to_h), player_id: player.id }
      end
    end
  end
end
