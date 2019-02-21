# frozen_string_literal: true

module PlayerLogin
  extend ActiveSupport::Concern

  included do
    helper_method :player_logged_in?

    def self.require_player_login(opts = {})
      before_action :require_player_login, opts
    end

    def self.skip_player_login(opts = {})
      skip_before_action :require_player_login, opts
    end
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
end
