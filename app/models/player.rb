# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user, optional: true
  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players

  validates :own_name, presence: true, unless: :user
  validates :own_name, absence: true, if: :user
  validates :user, uniqueness: true, allow_nil: true

  def own_name
    columns[:name]
  end

  def name
    return user.name if user

    super
  end
end
