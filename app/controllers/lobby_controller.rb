# frozen_string_literal: true

class LobbyController < ApplicationController
  require_player_login

  def show
    @matches = MatchSerializer.from_collection_as_json(Match.unmatched)
  end
end
