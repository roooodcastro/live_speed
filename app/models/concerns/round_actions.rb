# frozen_string_literal: true

module RoundActions
  extend ActiveSupport::Concern

  def perform_subscribed(player_id, round_id)
    @round_id = round_id
    round     = load_round(round_id)
    round.mark_player_connected(player_id, true)
    response_params('player_connected', round, player_id: player_id)
  end

  def perform_unsubscribed(player_id, round_id)
    round = load_round(round_id)
    round.mark_player_connected(player_id, false)
    response_params('player_disconnected', round, player_id: player_id)
  end

  def perform_fetch_data(player_id, round_id)
    round = load_round(round_id)
    response_params('round_data', round, player_id: player_id)
  end

  def perform_play_card(round_id, args)
    round       = load_round(round_id)
    card_info   = args.symbolize_keys
    played_card = round.play_card!(card_info)
    response    = card_info.slice(:card_index, :pile_index, :player_id).merge(
      success:   played_card.present?,
      card_data: played_card
    )
    response_params('play_response', round, response)
  end

  def perform_play_replacement(round_id, args)
    round  = load_round(round_id)
    played = round.use_replacement_pile!(args['player_id'])
    response_params('replacement_response', round, success: played)
  end

  def perform_player_ready(round_id, args)
    round = load_round(round_id)
    round.mark_player_as_ready(args['player_id'])
    response_params('player_ready', round, player_id: args['player_id'], all_players_ready: round.playing?)
  end

  private

  def load_round(round_id)
    Round.find(round_id)
  end

  def round_data(round)
    Round.cpu_mutex.synchronize { round.reload.data.as_json.merge(match_id: round.match_id) }
  end

  def response_params(action, round, extra_data)
    { action: action, round: round_data(round) }.merge(extra_data)
  end
end
