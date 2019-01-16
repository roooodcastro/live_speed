# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :player_id

    def connect
      # self.player_id = cookies.signed[:player_id]
      self.player_id = SecureRandom.urlsafe_base64
    end
  end
end
