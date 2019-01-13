# frozen_string_literal: true

class RenameHabtmTables < ActiveRecord::Migration[5.2]
  def change
    rename_table :games_players, :game_players
  end
end
