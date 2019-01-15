# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games, id: :uuid do |t|
      t.integer :status
      t.integer :num_rounds
      t.uuid :winner_id

      t.index :winner_id
      t.foreign_key :players, column: :winner_id

      t.timestamps
    end
  end
end
