class DropTournament < ActiveRecord::Migration[6.0]
  def change
  	drop_table :tournaments
  end
end
