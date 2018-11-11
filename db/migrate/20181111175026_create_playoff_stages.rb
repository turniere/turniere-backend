# frozen_string_literal: true

class CreatePlayoffStages < ActiveRecord::Migration[5.2]
  def change
    create_table :playoff_stages do |t|
      t.integer :id
      t.integer :level
      t.reference :matches

      t.timestamps
    end
  end
end
