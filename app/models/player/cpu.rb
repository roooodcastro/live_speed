# frozen_string_literal: true

class Player
  class CPU < Player
    include RoundActions

    attribute :own_name, :string, default: -> { Faker::Superhero.name }

    def name
      own_name
    end

    def play!(round)
      Round.cpu_mutex.synchronize do
        round.reload
        controller = round.round_controller

        unless controller.player_ready?(id)
          player_ready!(round)
          return
        end

        Rails.logger.info "Playing round #{round.id}!"
      end
    end

    def player_ready!(round)
      response_params = perform_player_ready(round.id, 'player_id' => id)
      broadcast_to_action_cable(round.id, response_params)
      Rails.logger.info 'Setting CPU player as ready!'
    end

    def broadcast_to_action_cable(round_id, response_params)
      ActionCable.server.broadcast "round_#{round_id}", response_params
    end
  end
end
