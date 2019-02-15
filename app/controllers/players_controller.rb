# frozen_string_literal: true

class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create; end
end
