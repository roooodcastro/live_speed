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

    flash[:error] = t('.error', error: @user.errors.full_messages.join(', '))
    render :new
  end

  def edit; end

  def update; end

  def destroy; end

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
end
