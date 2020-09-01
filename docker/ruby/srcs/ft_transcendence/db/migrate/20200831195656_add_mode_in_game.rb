class AddModeInGame < ActiveRecord::Migration[6.0]
  def change
  	add_column :games, :mode, :string
  end
end
