class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|
      t.integer :board_id
      t.integer :player_id
      t.string :val
      t.integer :x_value
      t.integer :y_value

      t.timestamps
    end
  end
end
