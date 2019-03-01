# frozen_string_literal: true

class MyAccountController < ApplicationController
  require_user_login

  before_action :set_user, only: %i[show edit update destroy]

  def show; end

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
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def error_flash(user)
    subtitle = user.errors.full_messages.join("\n")
    flash[:error] = [t('.error'), subtitle]
  end
end
