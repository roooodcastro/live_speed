# frozen_string_literal: true

class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    player = Player.create!(player_params)
    session[:player_id] = player.id
    flash[:notice] = "You're all set! You can now enter an existing match or create your own!"
    redirect_to lobby_path
  rescue StandardError => e
    Rails.logger.error(e.full_message)
    flash[:error] = 'An error occurred. Please try again.'
    redirect_to new_player_path
  end

  private

  def player_params
    params.require(:player).permit(:own_name)
  end
end
