# frozen_string_literal: true

class RoundDecorator < ApplicationDecorator
  delegate :round_controller, to: :object
  delegate :hands, :central_pile, :replacement_piles, to: :round_controller

  def player_card(player_index, card_index)
    card = hands[player_index].cards[card_index]
    return format_card(card) if card

    '&nbsp;'.html_safe
  end

  def has_replacement_cards?
    replacement_piles.first.present?
  end

  def has_draw_cards?(player_index)
    hands[player_index].draw_pile.present?
  end

  def possible_plays(player_index)
    hands[player_index].possible_plays(central_pile.top_cards)
  end

  def central_pile_top_card(pile_index)
    format_card(central_pile.top_cards[pile_index])
  end

  def format_card(card)
    color = card.suit.in?([:d, :h]) ? :red : :black
    view.content_tag(:span, card.to_unicode, style: "color: #{color}")
  end
end