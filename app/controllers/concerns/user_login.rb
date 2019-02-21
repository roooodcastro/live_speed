# frozen_string_literal: true

module UserLogin
  extend ActiveSupport::Concern

  included do
    helper_method :user_logged_in?

    def self.require_user_login(opts = {})
      before_action :require_user_login, opts
    end

    def self.skip_user_login(opts = {})
      skip_before_action :require_user_login, opts
    end
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
    redirect_to new_sessions_path unless user_logged_in?
  end
end
