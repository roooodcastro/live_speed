# frozen_string_literal: true

class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update]
  before_action :require_login

  respond_to :html, :json

  def index
    @matches = Match.all

    respond_with(@matches)
  end

  def show
    respond_with(@match)
  end

  def edit
    respond_with(@match)
  end

  def new
    @match = Match.new
    respond_with(@match)
  end

  def create
    @match = Match.create(match_params)
    respond_with(@match)
  end

  def update
    @match.send(match_params[:action])
    respond_with(@match)
  end

  def join
    match = params[:match_id].present? ? Match.find(params[:match_id]) : Match.unmatched.sample
    if match.add_player(current_player)
    else
    end
  end

  def destroy
    @match.destroy
    respond_with(@match)
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params[:match].permit(:num_rounds, :action)
  end
end
