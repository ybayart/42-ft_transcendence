class AddPointsInGame < ActiveRecord::Migration[6.0]
  def change
  	add_column :games, :player1_pts, :integer, default: 0
  	add_column :games, :player2_pts, :integer, default: 0
  end
end
