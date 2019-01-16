# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :match

  GAMES = {
    speed: { setup: 'Games::Speed::Setup', controller: 'Games::Speed::RoundController' }
  }

  STATUS_CREATED  = 0
  STATUS_PLAYING  = 1
  STATUS_PAUSED   = 2
  STATUS_FINISHED = 3

  ALL_STATUS = [STATUS_CREATED, STATUS_PLAYING, STATUS_PAUSED, STATUS_FINISHED]

  validates :number, presence: true, numericality: true
  validates :status, inclusion: { in: ALL_STATUS }

  delegate :players, :rules, to: :match
  delegate :print_game, :finished?, :unfinished?, to: :round_controller

  def setup_round!
    update!(data: setup_class.new(players, rules).to_h)
  end

  def play_card!(args)
    round_controller.play_card!(args[:player_id], args[:card_index].to_i, args[:pile_index].to_i)
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

  def status
    data['status']
  end

  def status=(new_status)
    data['status'] = new_status
  end

  private

  def update_round!
    self.data = round_controller.to_h.merge(status: status)
    check_for_winner
    save!

    round_controller.print_game
  end

  def check_for_winner
    self.winner = round_controller.winner if round_controller.finished?
  end

  def controller_class
    klass = GAMES[data['game_name'].to_sym][:controller]
    raise StandardError, "Round Controller class for match '#{data['game_name']}' doesn't exist!" if klass.blank?
    klass.constantize
  end

  def setup_class
    klass = GAMES[data['game_name'].to_sym][:setup]
    raise StandardError, "Round Setup class for match '#{data['game_name']}' doesn't exist!" if klass.blank?
    klass.constantize
  end
end
