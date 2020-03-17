# frozen_string_literal: true

module UserLogin
  extend ActiveSupport::Concern

  included do
    helper_method :user_logged_in?, :current_user

    def self.require_user_login(opts = {})
      before_action :require_user_login, opts
    end

    def self.skip_user_login(opts = {})
      skip_before_action :require_user_login, opts
    end
  end

  def login_and_redirect_user(user)
    login_user(user)
    flash[:notice] = t('sessions.create.success')
    redirect_to lobby_path
  end

  def logout_and_redirect_user(path = root_path)
    reset_session
    cookies.clear
    flash[:notice] = t('sessions.destroy.success')
    redirect_to path
  end

  protected

  def current_user_id
    session[:user_id]
  end

  def user_logged_in?
    current_user_id.present?
  end

  def current_user
    return unless user_logged_in?

    @current_user ||= User.find(current_user_id)
  end

  def require_user_login
    redirect_to login_path unless user_logged_in?
  end

  def login_user(user)
    session[:user_id] = user.id
    session[:player_id] = user.player_id
    cookies.signed[:player_id] = session[:player_id]
  end
end
