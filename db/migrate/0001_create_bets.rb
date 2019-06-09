# frozen_string_literal: true

class CreateBets < ActiveRecord::Migration[5.2]
  def change
    create_table :bets do |t|
      t.references :user, index: true, null: false, foreign_key: { on_delete: :cascade }
      t.references :match, index: true, null: false, foreign_key: { on_delete: :cascade }
      t.references :team, index: true, null: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
