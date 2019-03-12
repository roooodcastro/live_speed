# frozen_string_literal: true

class MatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "round_#{params[:round_id]}"
    @round_id = params[:round_id]
    round     = load_round
    round.mark_player_connected(player_id, true)
    respond('player_connected', round, player_id: player_id)
  rescue StandardError => e
    handle_error(e)
  end

  def unsubscribed
    round = load_round
    round.mark_player_connected(player_id, false)
    respond('player_disconnected', round, player_id: player_id)
  rescue StandardError => e
    handle_error(e)
  end

  def fetch_data
    round = load_round
    respond('round_data', round, player_id: player_id)
  rescue StandardError => e
    handle_error(e)
  end

  def play_card(args)
    round       = load_round
    card_info   = args.symbolize_keys
    played_card = round.play_card!(card_info)
    response    = card_info.slice(:card_index, :pile_index, :player_id).merge(
      success:   played_card.present?,
      card_data: played_card
    )
    respond('play_response', round, response)
  rescue StandardError => e
    handle_error(e)
  end

  def play_replacement(args)
    round  = load_round
    played = round.use_replacement_pile!(args['player_id'])
    respond('replacement_response', round, success: played)
  rescue StandardError => e
    handle_error(e)
  end

  def player_ready(args)
    round = load_round
    round.mark_player_as_ready(args['player_id'])
    respond('player_ready', round, player_id: args['player_id'], all_players_ready: round.playing?)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def load_round
    # puts "\n\n\n"
    # puts "LOADING ROUND FOR #{Player.find(player_id).name}"
    # puts "\n\n\n"
    round = Round.find(@round_id).reload
    # puts round.round_controller.hands.map(&:cards)
    round
  end

  def round_data(round)
    round.reload.data.as_json.merge(match_id: round.match_id)
  end

  def respond(action, round, data)
    ActionCable.server.broadcast "round_#{round.id}", { action: action, round: round_data(round) }.merge(data)
  end

  def handle_error(error)
    ActionCable.server.broadcast "round_#{@round_id}", action: :error, message: error.message
  end
end
