# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :game

  validates :number, presence: true, numericality: true

  delegate :players, :rules, to: :game

  def setup_round!
    setup = Setup.new(players, rules)
    @hands = setup.hands
    @central_pile = setup.central_pile
    @replacements = setup.replacements
    update_round!
  end

  def play_card!(player_id, card_index, pile_index)
    hand = player_hand(player_id)
    card = hand.cards[card_index]
    raise 'Unable to play, card not found!' if card.blank?
    return unless central_pile.can_play?(card, pile_index)

    central_pile.play_card(hand.remove_card(card_index), pile_index)
    update_round!
  end

  def use_replacement_pile!
    return if !can_use_replacements? || replacements[0].empty?

    central_pile.put_initial_cards([replacements[0].pop, replacements[1].pop])
    update_round!
  end

  # Can only use the replacement piles if there's no possible plays left for both players.
  def can_use_replacements?
    hands.product(central_pile.top_cards).map { |hand, card| hand.possible_play?(card) }.none?
  end

  def hands
    @hands ||= data['hands'].map do |hand_hash|
      hand_hash[:player] = players.to_a.find { |player| player.id == hand_hash['player_id'].to_i }
      Hand.from_h(hand_hash.deep_symbolize_keys)
    end
  end

  def central_pile
    @central_pile ||= CentralPile.from_h(data['central_pile'].deep_symbolize_keys, [])
  end

  def replacements
    @replacements ||= data['replacements'].map do |rep_pile|
      rep_pile.map { |card| Card.from_h(card.deep_symbolize_keys) }
    end
  end

  # Temporary method to print relevant round info so I can play on the terminal
  def print_game # rubocop:disable Metrics/AbcSize
    hand1 = player_hand(1)
    hand2 = player_hand(2)
    Rails.logger.info "\nHand 1: #{hand1.cards.join(' ')}, #{hand1.draw_pile.size} extra"
    Rails.logger.info "Hand 2: #{hand2.cards.join(' ')}, #{hand2.draw_pile.size} extra"
    Rails.logger.info "\nPiles: #{central_pile.piles.map(&:last)}"
  end

  private

  def player_hand(player_id)
    hands.find { |hand| hand.player_id == player_id }
  end

  def update_round!
    self.data = {
      hands: hands.map(&:to_h),
      replacements: replacements.map { |pile| pile.map(&:to_h) },
      central_pile: central_pile.to_h
    }
    check_for_winner
    save!

    print_game
  end

  def check_for_winner
    hands.each do |hand|
      next if hand.cards.present?

      self.winner = hand.player
    end
  end
end
