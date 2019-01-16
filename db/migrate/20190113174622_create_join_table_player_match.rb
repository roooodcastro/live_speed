# frozen_string_literal: true

class CreateJoinTablePlayerMatch < ActiveRecord::Migration[5.2]
  def change
    create_table :match_players, id: :uuid do |t|
      t.references :match, type: :uuid, foreign_key: true
      t.references :player, type: :uuid, foreign_key: true

      t.index %i[player_id match_id]
      t.index %i[match_id player_id]
    end
  end
end
