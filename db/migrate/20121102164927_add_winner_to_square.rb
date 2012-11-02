class AddWinnerToSquare < ActiveRecord::Migration
  def change
    add_column :squares, :winner, :boolean
  end
end
