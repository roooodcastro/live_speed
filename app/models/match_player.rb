# frozen_string_literal: true

class MatchPlayer < ApplicationRecord
  belongs_to :match, inverse_of: :match_players
  belongs_to :player, inverse_of: :match_players

  validates :player_id, uniqueness: { scope: :match_id }
end
