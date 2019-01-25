# frozen_string_literal: true

class MatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{player_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def fetch_data
    puts 'Fetching round data'
    ActionCable.server.broadcast "player_#{player_id}", { action: 'here are some data' }
  end

  def play_card(args)
    card = args['card']
    pile_index = args['pile_index']
    puts "Playing card #{card} on pile #{pile_index}!"
  end

  def play_replacement
    puts 'Playing replacement pile!'
  end
end
