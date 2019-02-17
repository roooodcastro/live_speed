# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user, optional: true
  has_many :match_players, dependent: :destroy
  has_many :matches, through: :match_players, inverse_of: :players

  validates :own_name, presence: true, unless: :user
  validates :own_name, length: { minimum: 4, allow_nil: true }
  validates :own_name, absence: true, if: :user
  validates :user, uniqueness: true, allow_nil: true

  def name
    return user.name if user

    own_name
  end

  # Needs to check if there's another Player or User with this name.
  def self.validate_name(name)
    return '' if name.blank? # Not valid, but don't show any error
    return 'Name is too short' if name.size < 4
    return 'Name is already taken' if Player.exists?(own_name: name) || User.exists?(name: name)
  end
end
