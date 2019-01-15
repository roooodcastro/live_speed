# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds, id: :uuid do |t|
      t.integer :number
      t.uuid :game_id
      t.uuid :winner_id
      t.json :data

      t.index :winner_id
      t.index :game_id
      t.foreign_key :players, column: :winner_id
      t.foreign_key :games, column: :game_id

      t.timestamps
    end
  end
end
