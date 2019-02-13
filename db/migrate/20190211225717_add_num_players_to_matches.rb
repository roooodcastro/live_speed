# frozen_string_literal: true

class AddNumPlayersToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :num_players, :integer, null: false, default: 2
  end
end
