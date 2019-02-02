# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :match

  GAMES = {
    speed: { setup: 'Games::Speed::Setup', controller: 'Games::Speed::RoundController' }
  }.freeze

  STATUS_CREATED  = 0
  STATUS_PLAYING  = 1
  STATUS_PAUSED   = 2
  STATUS_FINISHED = 3

  ALL_STATUS = [STATUS_CREATED, STATUS_PLAYING, STATUS_PAUSED, STATUS_FINISHED].freeze

  USE_CACHE = false

  validates :number, presence: true, numericality: true

  delegate :players, :rules, to: :match
  delegate :print_game, :finished?, :unfinished?, :can_use_replacement_pile?, to: :round_controller

  def setup_round!
    update!(data: setup_class.new(players, rules).to_h)
  end

  def play_card!(args)
    played_card = round_controller.play_card(args[:player_id], args[:card_index].to_i, args[:pile_index].to_i)
    update_round! if played_card.present?
    played_card
  end

  def use_replacement_pile!
    return false unless round_controller.use_replacement_pile

    update_round!
  end

  def mark_player_as_ready(player_id)
    round_controller.mark_player_as_ready(player_id)
    self.status = STATUS_PLAYING if round_controller.players_ready?
    update_round!
  end

  def round_controller
    @round_controller ||= controller_class.send(:from_h, cached_data)
  end

  def commit_changes!
    update_round!
  end

  def status
    data['status']
  end

  def status=(new_status)
    data['status'] = new_status if new_status.in? ALL_STATUS
  end

  def playing?
    status == STATUS_PLAYING
  end

  private

  def update_round!
    self.data = round_controller.to_h.merge(status: status)
    check_for_winner
    return update_to_cache! if USE_CACHE

    save!
    true
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

  def cached_data
    return data.deep_symbolize_keys unless USE_CACHE

    Rails.cache.fetch("round_data_#{id}") { data.deep_symbolize_keys }
  end

  def update_to_cache!
    Rails.cache.write("round_data_#{id}", round_controller.to_h.merge(status: status))
    true
  end
end
