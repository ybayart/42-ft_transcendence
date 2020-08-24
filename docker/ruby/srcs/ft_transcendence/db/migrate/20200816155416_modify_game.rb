class ModifyGame < ActiveRecord::Migration[6.0]
  def change
  	remove_column(:games, :nb)
  	add_reference(:games, :player1, foreign_key: {to_table: :users})
  	add_reference(:games, :player2, foreign_key: {to_table: :users})
  end
end
