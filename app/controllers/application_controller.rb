# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_player

  private

  def logged_in?
    session[:player_id].present?
  end

  def current_player
    return nil unless session[:player_id]

    Player.find(session[:player_id])
  end

  def require_login
    redirect_to new_sessions_path if session[:player_id].blank?
  end
end
