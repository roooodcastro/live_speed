# frozen_string_literal: true

if User.find_by(name: 'Rodrigo').blank?
  user1 = User.create name: 'Rodrigo', email: 'rodrigo@email.com', password: '123456'
end

if User.find_by(name: 'Gabi').blank?
  user2 = User.create name: 'Gabi', email: 'gabi@email.com', password: '123456'
end

player1 = Player.find_or_create_by user: user1
player2 = Player.find_or_create_by user: user2

match = Match.find_or_create_by num_rounds: 5, players: [player1, player2]
match.current_round