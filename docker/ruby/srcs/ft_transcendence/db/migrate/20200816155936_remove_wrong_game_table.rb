class RemoveWrongGameTable < ActiveRecord::Migration[6.0]
  def change
  	drop_table :game
  end
end
