# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user, optional: true
  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players

  validates :name, presence: true, unless: :user
  validates :name, absence: true, if: :user
  validates :user, uniqueness: true, allow_nil: true

  def player_name
    return user.name if user

    name
  end
end
