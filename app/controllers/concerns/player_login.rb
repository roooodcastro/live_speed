# frozen_string_literal: true

module PlayerLogin
  extend ActiveSupport::Concern

  included do
    helper_method :player_logged_in?, :current_player, :current_player_id

    def self.require_player_login(opts = {})
      before_action :require_player_login, opts
    end

    def self.skip_player_login(opts = {})
      skip_before_action :require_player_login, opts
    end
  end

  def login_and_redirect_player(player)
    login_player(player)
    flash[:notice] = t('players.create.success')
    redirect_to lobby_path
  end

  def logout_and_redirect_player(path = root_path)
    reset_session
    cookies.clear
    flash[:notice] = t('players.destroy.success')
    redirect_to path
  end

  protected

  def current_player_id
    session[:player_id]
  end

  def player_logged_in?
    current_player_id.present?
  end

  def current_player
    return unless player_logged_in?

    @current_player ||= Player.find(current_player_id)
  end

  def require_player_login
    redirect_to new_sessions_path unless player_logged_in?
  end

  def login_player(player)
    session[:player_id] = player.id
    cookies.signed[:player_id] = session[:player_id]
  end
end
