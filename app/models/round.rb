# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :game

  GAMES = {
    speed: { setup: 'Speed::Setup', controller: 'Speed::RoundController' }
  }

  validates :number, presence: true, numericality: true

  delegate :players, :rules, to: :game

  def setup_round!
    setup_class = GAMES[data['game_name'].to_sym][:setup].constantize
    update!(data: setup_class.new(players, rules).to_h)
  end

  def play_card!(player_id, card_index, pile_index)
    round_controller.play_card!(player_id, card_index, pile_index)
    update_round!
  end

  def use_replacement_pile!
    round_controller.use_replacement_pile!
    update_round!
  end

  def round_controller
    data_with_players = data.deep_symbolize_keys
    data_with_players[:players] = players.to_a
    controller_class = GAMES[data_with_players[:game_name].downcase.to_sym][:controller].constantize
    @round_controller ||= controller_class.send(:from_h, data_with_players)
  end

  private

  def update_round!
    self.data = round_controller.to_h
    check_for_winner
    save!

    round_controller.print_game
  end

  def check_for_winner
    self.winner = round_controller.winner if round_controller.finished?
  end
end
