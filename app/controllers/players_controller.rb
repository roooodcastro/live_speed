# frozen_string_literal: true

class PlayersController < ApplicationController
  include ControllerAttributeValidator

  layout 'login', only: :new

  def new
    if player_logged_in?
      flash[:notice] = t('.already_logged_in')
      return redirect_to lobby_path
    end

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
