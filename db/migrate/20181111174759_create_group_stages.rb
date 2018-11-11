# frozen_string_literal: true

class CreateGroupStages < ActiveRecord::Migration[5.2]
  def change
    create_table :group_stages do |t|
      t.integer :id
      t.reference :groups
      t.integer :playoff_size

      t.timestamps
    end
  end
end
