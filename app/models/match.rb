# frozen_string_literal: true

class Match < ApplicationRecord
  attr_accessor :cpu_match

  belongs_to :winner, class_name: 'Player', optional: true
  has_many :rounds, -> { order(created_at: :asc) }, dependent: :destroy, inverse_of: :match
  has_many :match_players, dependent: :destroy
  has_many :players, through: :match_players, inverse_of: :matches

  validates :num_rounds, presence: true, numericality: true
  validates :num_players, numericality: { between: 2..4 }
  validates :match_players, length: { in: 1..4 }

  after_create :create_cpu_players

  scope :from_player, ->(player_id) { joins(:match_players).where match_players: { player_id: player_id } }
  scope :with_players, -> { includes players: :user }
  scope :with_rounds, -> { includes :rounds }

  scope :unmatched, lambda {
    joins(:players)
      .group('matches.id')
      .having(Arel.sql('count(players.id) < num_players'))
  }

  def add_player!(player)
    match_players.build(player: player)
    save
  end

  def current_round(create_new_round = true)
    return latest_round if latest_round&.unfinished?

    create_next_round! if create_new_round
  end

  def create_next_round!
    check_for_winner!
    return if finished?

    round_number = rounds.count + 1
    return latest_round if round_number > num_rounds

    round = rounds.new(number: round_number, data: { game_name: 'speed' })
    round.setup_round!
    round
  end

  def latest_round
    rounds.last
  end

  def derive_winner_id
    round_winners   = rounds.pluck(:winner_id)
                            .group_by(&:itself)
                            .transform_values(&:size)
                            .except(nil)
    most_round_wins = round_winners.max_by(&:last)
    return unless most_round_wins # If no one has won a round yet

    most_round_wins.first if most_round_wins.last > num_rounds / 2
  end

  def check_for_winner!
    possible_winner_id = derive_winner_id
    return unless possible_winner_id

    update(winner_id: possible_winner_id)
  end

  def winner
    players.to_a.find { |player| (player.id == winner_id) }
  end

  def finished?
    winner_id.present?
  end

  def can_play?
    match_players.size == num_players && !winner_id
  end

  def include_cpu_player?
    players.where(type: Player::CPU.name).exists?
  end

  def description
    key_name = finished? ? 'description_finished' : 'description_unfinished'

    I18n.t("activerecord.attributes.match.#{key_name}",
           players: num_players, rounds: num_rounds, winner: winner&.name)
  end

  def rules
    []
  end

  private

  def create_cpu_players
    return unless cpu_match

    Array.new(num_players - players.count).each { players << Player::CPU.create }
  end
end
