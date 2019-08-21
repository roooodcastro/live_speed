# frozen_string_literal: true

class Player
  class CPU < Player
    include RoundActions

    attribute :own_name, :string, default: -> { Faker::Superhero.name }

    attr_reader :current_round

    def name
      own_name
    end

    def play!(round) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      Round.cpu_mutex.synchronize do
        @current_round = round.reload
        controller     = current_round.round_controller

        return connect unless controller.player_connected?(id)
        return disconnect if controller.finished?
        return player_ready unless controller.player_ready?(id)
        return play_replacement if controller.can_use_replacement_piles?
        return unless controller.players_ready? && controller.players_connected?

        play_card
      end
    end

    private

    def connect
      response_params = perform_subscribed(id, current_round.id)
      broadcast_to_action_cable(current_round.id, response_params)
      log('Connected!')
    end

    def disconnect
      response_params = perform_unsubscribed(id, current_round.id)
      broadcast_to_action_cable(current_round.id, response_params)
      log('Round is over! Disconnecting player!')
    end

    def player_ready
      response_params = perform_player_ready(current_round.id, 'player_id' => id)
      broadcast_to_action_cable(current_round.id, response_params)
      log('Setting CPU player as ready!')
    end

    def play_replacement
      response_params = perform_play_replacement(current_round.id, 'player_id' => id)
      broadcast_to_action_cable(current_round.id, response_params)
      log('CPU playing replacement pile!')
    end

    def play_card
      params = play_card_params
      return log('No valid card to play! Skipping...') if params.blank?

      response_params = perform_play_card(current_round.id, params)
      broadcast_to_action_cable(current_round.id, response_params)
      log_play_card(params)
    end

    def play_card_params
      possible_plays = find_possible_plays
      return if possible_plays.blank?

      chosen_play = possible_plays.to_a.sample
      chosen_pile = chosen_play[1].sample
      {
        player_id:  id,
        card_index: chosen_play[0].to_i,
        pile_index: chosen_pile
      }
    end

    def find_possible_plays
      hand         = current_round.round_controller.player_hand(id)
      central_pile = current_round.round_controller.central_pile
      hand.possible_plays(central_pile.top_cards)
    end

    def broadcast_to_action_cable(round_id, response_params)
      ActionCable.server.broadcast "round_#{round_id}", response_params
    end

    def log(message)
      Rails.logger.info(Rainbow("[CPU] #{name}: #{message}").green.bright)
    end

    def log_play_card(params)
      hand = current_round.player_hand(id)
      card = hand.cards[params[:card_index]]
      log("Playing card #{card} into pile #{params[:pile_index]}")
    end
  end
end
