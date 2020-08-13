class AddColumnInGame < ActiveRecord::Migration[6.0]
  def change
  	create_table :game
  	add_column :game, :nb, :decimal, default: 0
  end
end
