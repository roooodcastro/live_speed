# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :player, dependent: :nullify

  delegate :id, to: :player, prefix: true

  validates :name, presence: true, uniqueness: true, length: { minimum: 4 }

  def self.create_with_player(params)
    rescued_transaction do
      user = User.create!(params)
      Player.create!(user: user)
      user
    end
  end

  def destroy_and_anonymize_player
    User.rescued_transaction do
      player.update!(own_name: '[Anonymous]', user: nil)
      destroy!
      true
    end
  end
end
