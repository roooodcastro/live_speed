# frozen_string_literal: true

class Player
  class CPU < Player
    attribute :own_name, :string, default: -> { Faker::Superhero.name }

    def name
      own_name
    end
  end
end
