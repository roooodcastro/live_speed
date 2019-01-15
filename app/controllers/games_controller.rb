# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update]

  respond_to :html, :json

  def index
    @games = Game.all

    respond_with(@games)
  end

  def show
    respond_with(@game)
  end

  def edit
    respond_with(@game)
  end

  def new
    @game = Game.new
    respond_with(@game)
  end

  def create
    @game = Game.create(game_params)
    respond_with(@game)
  end

  def update
    @game.send(game_params[:action])
    respond_with(@game)
  end

  def destroy
    @game.destroy
    respond_with(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params[:game].permit(:num_rounds, :action)
  end
end
