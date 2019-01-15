# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :game

  GAMES = {
    speed: { setup: 'Games::Speed::Setup', controller: 'Games::Speed::RoundController' }
  }

  validates :number, presence: true, numericality: true

  delegate :players, :rules, to: :game
  delegate :print_game, :finished?, :unfinished?, to: :round_controller

  def setup_round!
    update!(data: setup_class.new(players, rules).to_h)
  end

  def play_card!(args)
    round_controller.play_card!(args[:player_id].to_i, args[:card_index].to_i, args[:pile_index].to_i)
    update_round!
  end

  def use_replacement_pile!(_)
    round_controller.use_replacement_pile!
    update_round!
  end

  def round_controller
    @round_controller ||= begin
      data_with_players = data.deep_symbolize_keys
      data_with_players[:hands].each { |hand| hand[:players] = players.to_a }
      controller_class.send(:from_h, data_with_players)
    end
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

  def controller_class
    klass = GAMES[data['game_name'].to_sym][:controller]
    raise StandardError, "Round Controller class for game '#{data['game_name']}' doesn't exist!" if klass.blank?
    klass.constantize
  end

  def setup_class
    klass = GAMES[data['game_name'].to_sym][:setup]
    raise StandardError, "Round Setup class for game '#{data['game_name']}' doesn't exist!" if klass.blank?
    klass.constantize
  end
end
