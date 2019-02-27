# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'login'

  def new
    redirect_to root_path if user_logged_in?
  end

  def create
    user = User.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      login_user(user)
      redirect_back(fallback_location: root_path)
    else
      render :new, error: t('.error')
    end
  end

  def destroy
    reset_session
    cookies.clear
    redirect_to new_sessions_path
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def login_user(user)
    session[:user_id] = user.id
    session[:player_id] = user.fetch_or_create_player!.id
    cookies.signed[:player_id] = session[:player_id]
  end
end
