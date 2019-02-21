# frozen_string_literal: true

class RoundsController < ApplicationController
  require_player_login

  respond_to :html, :json

  before_action :set_round, only: %i[show edit update]

  def show
    respond_with(@round)
  end

  def edit
    respond_with(@round)
  end

  def new
    @round = Round.new
    respond_with(@round)
  end

  def create
    @round = Round.create(round_params)
    respond_with(@round)
  end

  def update
    @round.send(round_params[:action], round_params)
    respond_with(@round)
  end

  def destroy
    @round.destroy
    respond_with(@round)
  end

  private

  def set_round
    @round = RoundDecorator.decorate(Round.find(params[:id]), view_context)
  end

  def round_params
    params[:round].permit(:number, :match_id, :player_id, :card_index, :pile_index, :action)
  end
end
