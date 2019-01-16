# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players, id: :uuid do |t|
      t.string :own_name
      t.references :user, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
