class MatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{player_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
