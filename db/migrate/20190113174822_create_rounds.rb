# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[5.2]
  def change
    create_table :rounds, id: :uuid do |t|
      t.integer :number
      t.json :data

      t.references :winner, type: :uuid, foreign_key: { to_table: :players }
      t.references :game, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
