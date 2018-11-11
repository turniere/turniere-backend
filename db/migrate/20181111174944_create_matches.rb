class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :id
      t.reference :team_1
      t.reference :team_2
      t.integer :score_team_1
      t.integer :score_team_2
      t.integer :state
      t.integer :position
      t.boolean :is_group_match

      t.timestamps
    end
  end
end
