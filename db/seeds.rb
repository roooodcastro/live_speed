# frozen_string_literal: true

require 'faker'

User.create_with_player name: 'Admin', email: 'admin@email.com', password: '123456'

users = Array.new(2) do
  user_name = Faker::Name.first_name
  User.create_with_player name: user_name, email: "#{user_name.downcase}@email.com", password: '123456'
end

match = Match.find_or_create_by num_rounds: 5, num_players: users.size, players: users.map(&:player)
match.current_round
