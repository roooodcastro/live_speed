# frozen_string_literal: true

class MatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "round_#{params[:round_id]}"
    @round = Round.find(params[:round_id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def fetch_data
    respond('round_data', player_id: player_id, round: @round.data.as_json)
  end

  def play_card(args)
    card_info   = args.symbolize_keys
    played_card = @round.reload.play_card!(card_info)
    response    = card_info.slice(*%i[card_index pile_index player_id]).merge(
      success:       played_card.present?,
      card_data:     played_card,
      round:         @round.as_json
    )
    respond('play_response', response)
  end

  def play_replacement(args)
    played = @round.use_replacement_pile!(args['player_id'])
    respond('replacement_response', success: played)
  end

  def player_ready(args)
    @round.mark_player_as_ready(args['player_id'])
    respond('player_ready', player_id: args['player_id'], all_players_ready: @round.playing?)
  end

  private

  def respond(action, data)
    ActionCable.server.broadcast "round_#{@round.id}", { action: action }.merge(data)
  end
end
