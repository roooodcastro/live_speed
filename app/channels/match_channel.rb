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
    respond('round_data', @round.data.as_json)
  end

  def play_card(args)
    card_info   = args.symbolize_keys
    played_card = @round.reload.play_card!(card_info)
    response    = {
      success:    played_card.present?,
      card_data:  played_card,
      card_index: card_info[:card_index],
      pile_index: card_info[:pile_index],
      player_id:  card_info[:player_id]
    }
    respond('play_response', response)
  end

  def play_replacement
    puts 'Playing replacement pile!'
  end

  private

  def respond(action, data)
    ActionCable.server.broadcast "round_#{@round.id}", { action: action }.merge(data)
  end
end
