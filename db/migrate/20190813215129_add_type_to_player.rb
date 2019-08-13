# frozen_string_literal: true

class AddTypeToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :type, :string, default: 'Player', null: false
  end
end
