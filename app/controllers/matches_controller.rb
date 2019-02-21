# frozen_string_literal: true

class MatchesController < ApplicationController
  require_player_login

  respond_to :html, :json

  layout 'game', only: :play

  before_action :set_match, only: %i[show play edit update]

  def index
    @matches = Match.from_player(current_player_id)

    respond_with(@matches)
  end

  def show
    respond_with(@match)
  end

  def play
    return redirect_to @match unless @match.can_play?

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
    @match = current_player.matches.create(match_params)
    respond_with(@match)
  end

  def update
    @match.update(match_params)
    respond_with(@match)
  end

  def join
    match = params[:match_id].present? ? Match.find(params[:match_id]) : Match.unmatched.sample
    if match.add_player!(current_player)
      redirect_to match
    else
      flash[:error] = 'Cannot join match!'
      redirect_to lobby_path
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
    params[:match].permit(:num_rounds, :num_players)
  end
end
