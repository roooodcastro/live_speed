# frozen_string_literal: true

class CreateJoinTablePlayerGame < ActiveRecord::Migration[5.2]
  def change
    create_table :game_players, id: :uuid do |t|
      t.uuid :player_id
      t.uuid :game_id

      t.index %i[player_id game_id]
      t.index %i[game_id player_id]

      t.foreign_key :players, column: :player_id
      t.foreign_key :games, column: :game_id
    end
  end
end
