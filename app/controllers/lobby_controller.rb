# frozen_string_literal: true

class LobbyController < ApplicationController
  require_player_login

  def show
    @matches = Match.unmatched
  end
end
