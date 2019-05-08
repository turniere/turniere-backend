class AddWinnerToMatch < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :winner, :Team
  end
end
