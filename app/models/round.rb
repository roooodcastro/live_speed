# frozen_string_literal: true

class Round < ApplicationRecord # rubocop:disable Metrics/ClassLength
  @@cpu_mutex = Monitor.new # rubocop:disable Style/ClassVars
  cattr_reader :cpu_mutex

  belongs_to :winner, class_name: 'Player', optional: true
  belongs_to :match
  has_many :players, through: :match, inverse_of: :rounds

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
  delegate :finished?, :unfinished?, :can_use_replacement_piles?, :player_hand, to: :round_controller

  scope :with_status, ->(status) { where("data->> 'status' IN (?)", Array(status).map(&:to_s)) }
  scope :created_or_playing, -> { with_status([STATUS_CREATED, STATUS_PLAYING]) }
  scope :with_cpu_players, -> { joins(match: :players).where(players: { type: Player::CPU.name }) }

  def setup_round!
    update!(data: setup_class.new(players, rules).to_h.merge(status: status, match: match.rounds_info))
  end

  def play_card!(args)
    thread_safe do
      return if paused?

      played_card = round_controller.play_card(args[:player_id], args[:card_index].to_i, args[:pile_index].to_i)
      update_round! if played_card.present?
      played_card
    end
  end

  def use_replacement_pile!(player_id)
    thread_safe do
      return false if paused?

      round_controller.mark_player_replacement_ready(player_id)
      players_ready = round_controller.players_ready_for_replacement?
      update_round!

      return false unless players_ready
      return false unless round_controller.use_replacement_pile

      update_round!
    end
  end

  def mark_player_as_ready(player_id)
    thread_safe do
      round_controller.mark_player_as_ready(player_id)
      self.status = STATUS_PLAYING if round_controller.players_ready?
      update_round!
    end
  end

  def mark_player_connected(player_id, connected)
    thread_safe do
      round_controller.mark_player_connected(player_id, connected)
      check_for_pause
      update_round!
    end
  end

  def check_for_pause
    if playing?
      self.status = STATUS_PAUSED unless round_controller.players_connected?
    elsif paused?
      self.status = STATUS_PLAYING if round_controller.players_connected?
    end
  end

  def round_controller
    @round_controller ||= controller_class.send(:from_h, cached_data)
  end

  def status
    data['status'] || STATUS_CREATED
  end

  def status=(new_status)
    data['status'] = new_status if new_status.in? ALL_STATUS
  end

  def playing?
    status == STATUS_PLAYING
  end

  def paused?
    status == STATUS_PAUSED
  end

  def reload
    instance_variable_set(:@round_controller, nil)
    super
  end

  private

  def update_round!
    thread_safe do
      self.data = round_controller.to_h.merge(status: status, match: match.rounds_info)
      check_for_winner
      return update_to_cache! if USE_CACHE

      save!
      true
    end
  end

  def check_for_winner
    self.winner_id = round_controller.winner_id if round_controller.finished?
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
    Rails.cache.write("round_data_#{id}", round_controller.to_h.merge(status: status, match: match.rounds_info))
    true
  end

  def thread_safe
    result = nil
    cpu_mutex.synchronize do
      result = yield
    end
    result
  end
end
