# frozen_string_literal: true

class CreateJoinTablePlayerGame < ActiveRecord::Migration[5.2]
  def change
    create_join_table :players, :games do |t|
      t.index %i[player_id game_id]
      t.index %i[game_id player_id]
    end
  end
end
