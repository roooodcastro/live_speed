# frozen_string_literal: true

class UsersController < ApplicationController
  include ControllerAttributeValidator

  require_user_login
  skip_user_login only: %i[index new create validate]

  layout 'login', only: %i[new create]

  before_action :set_user, only: %i[show edit update destroy]

  def index
    redirect_to new_user_path unless user_logged_in?
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.create_with_player(user_params)
    return login_and_redirect_user(@user) if @user.persisted?

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

  def error_flash(user)
    subtitle = user.errors.full_messages.join("\n")
    flash.now[:error] = [t('.error'), subtitle]
  end
end
