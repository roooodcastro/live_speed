# frozen_string_literal: true

class PlayerNameValidatorsController < ApplicationController
  def create
    error = Player.validate_name(params[:name].strip)
    render json: { valid: error.nil?, error: error.to_s }
  end
end
