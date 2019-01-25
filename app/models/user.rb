# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :player

  validates :name, presence: true, uniqueness: true

  def get_or_create_player!
    return player if player

    Player.create!(user: self)
  end
end
