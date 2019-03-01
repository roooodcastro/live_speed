# frozen_string_literal: true

class UsersController < ApplicationController
  require_user_login
  skip_user_login only: %i[new create]

  layout 'login', only: :new

  before_action :set_user, only: %i[show edit update destroy]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    return login_and_redirect(@user) if @user.persisted?

    error_flash(@user)
    render :new
  end

  def edit; end

  def update
    updated = @user.update(user_params)
    return redirect_to @user if updated

    error_flash(@user)
    render :edit
  end

  def destroy
    destroyed = @user.destroy_and_anonymize_player
    return logout_and_redirect if destroyed

    error_flash(@user)
    render :show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def login_and_redirect(user)
    login_user(user)
    flash[:notice] = t('.success')
    redirect_back(fallback_location: root_path)
  end

  def logout_and_redirect
    reset_session
    cookies.clear
    flash[:notice] = t('.success')
    redirect_to root_path
  end

  def error_flash(user)
    subtitle = user.errors.full_messages.join("\n")
    flash[:error] = [t('.error'), subtitle]
  end
end
