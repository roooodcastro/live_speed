# frozen_string_literal: true

class MatchChannel < ApplicationCable::Channel
  include RoundActions

  def subscribed
    stream_from "round_#{params[:round_id]}"
    @round_id = params[:round_id]
    response_params = perform_subscribed(player_id, @round_id)
    respond(response_params)
  rescue StandardError => e
    handle_error(e)
  end

  def unsubscribed
    response_params = perform_unsubscribed(player_id, @round_id)
    respond(response_params)
  rescue StandardError => e
    handle_error(e)
  end

  def fetch_data
    response_params = perform_fetch_data(player_id, @round_id)
    respond(response_params)
  rescue StandardError => e
    handle_error(e)
  end

  def play_card(args)
    response_params = perform_play_card(@round_id, args)
    respond(response_params)
  rescue StandardError => e
    handle_error(e)
  end

  def play_replacement(args)
    response_params = perform_play_replacement(@round_id, args)
    respond(response_params)
  rescue StandardError => e
    handle_error(e)
  end

  def player_ready(args)
    response_params = perform_player_read(@round_id, args)
    respond(response_params)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def respond(response_params)
    CpuThreadOrchestrator.instance.ensure_is_running

    ActionCable.server.broadcast "round_#{@round_id}", response_params
  end

  def handle_error(error)
    ActionCable.server.broadcast "round_#{@round_id}", action: :error, message: error.message
  end
end
