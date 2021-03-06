# frozen_string_literal: true

class Player < ApplicationRecord
  include ModelAttributeValidator

  belongs_to :user, optional: true
  has_many :match_players, dependent: :destroy
  has_many :matches, through: :match_players, inverse_of: :players

  validates :own_name, presence: true, unless: :user
  validates :own_name, absence: true, if: :user
  validates :own_name, length: { minimum: 4, allow_nil: true }
  validates :user, uniqueness: true, allow_nil: true

  def name
    return user.name if user

    own_name
  end
end
