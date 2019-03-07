# frozen_string_literal: true

class PlayersController < ApplicationController
  include ControllerAttributeValidator

  layout 'login', only: :new

  def new
    # TODO: Do a single page with the new user and player forms, both as playing cards on top of another. When the user
    # TODO: decides to change between creating a player or an account, have the bottom card swipe right/up while the
    # TODO: top card swipe in the opposite direction, and then change their z-index so the desired one stays on top.
    @player = Player.new
  end

  def create
    login_and_redirect_player(Player.create!(player_params))
  rescue StandardError => e
    Rails.logger.error(e.message)
    flash[:error] = t('.error')
    redirect_to new_player_path
  end

  private

  def player_params
    params.require(:player).permit(:own_name)
  end
end
