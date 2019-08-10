# frozen_string_literal: true

class MatchSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  def as_json # rubocop:disable Metrics/AbcSize
    {
      id:                  record.id,
      description:         record.description,
      join_url:            join_matches_path(match_id: record.id),
      num_rounds:          record.num_rounds,
      num_total_players:   record.num_players,
      num_current_players: record.players.count,
      current_round:       record.rounds.count
    }
  end
end
