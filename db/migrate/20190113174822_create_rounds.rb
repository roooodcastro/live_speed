# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds do |t|
      t.integer :number
      t.references :game, foreign_key: true
      t.integer :winner_id

      t.index :winner_id
      t.foreign_key :players, column: :winner_id

      t.timestamps
    end
  end
end
