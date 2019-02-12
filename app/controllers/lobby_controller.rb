# frozen_string_literal: true

class LobbyController < ApplicationController
  before_action :require_login

  def show
    @matches = Match.unmatched
  end
end
