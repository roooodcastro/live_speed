# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  include AttributeValidator

  has_one :player, dependent: :nullify

  delegate :id, to: :player, prefix: true

  validates :name, presence: true, uniqueness: true, length: { minimum: 4 }
  validates :email, presence: true, uniqueness: true

  def self.create_with_player(params)
    user = User.new(params)
    rescued_transaction do
      user.save!
      Player.create!(user: user)
    end
    user
  end

  def destroy_and_anonymize_player
    User.rescued_transaction do
      player.update!(own_name: '[Anonymous]', user: nil)
      destroy!
      true
    end
  end
end
