# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.integer :id
      t.string :name
      t.integer :group_score
      t.integer :group_points_scored
      t.integer :group_points_recieved

      t.timestamps
    end
  end
end
