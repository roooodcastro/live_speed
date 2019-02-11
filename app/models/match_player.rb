# frozen_string_literal: true

class MatchPlayer < ApplicationRecord
  belongs_to :match
  belongs_to :player

  validates :player_id, uniqueness: { scope: :match_id }
end
