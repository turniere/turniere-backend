class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :id
      t.references :matches, foreign_key: true
      t.references :teams, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
