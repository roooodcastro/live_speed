# frozen_string_literal: true

class AddDataToRounds < ActiveRecord::Migration[5.2]
  def change
    add_column :rounds, :data, :json
  end
end
