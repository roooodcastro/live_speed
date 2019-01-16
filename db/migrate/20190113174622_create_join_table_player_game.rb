# frozen_string_literal: true

class CreateJoinTablePlayerGame < ActiveRecord::Migration[5.2]
  def change
    create_table :game_players, id: :uuid do |t|
      t.references :game, type: :uuid, foreign_key: true
      t.references :player, type: :uuid, foreign_key: true

      t.index %i[player_id game_id]
      t.index %i[game_id player_id]
    end
  end
end
