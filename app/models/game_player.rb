# frozen_string_literal: true

class GamePlayer < ApplicationRecord
  belongs_to :game
  belongs_to :player
end
