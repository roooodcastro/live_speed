# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'login'

  def show
    redirect_to login_path
  end

  def new
    redirect_to root_path if user_logged_in?
  end

  def create
    user = User.find_by(email: login_params[:email])
    return login_and_redirect_user(user) if user&.authenticate(login_params[:password])

    flash.now[:error] = [t('.error_title'), t('.error')]
    render :new
  end

  def destroy
    logout_and_redirect_user(login_path)
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
