class CreateTournaments < ActiveRecord::Migration[6.0]
  def change
    create_table :tournaments do |t|
    	t.string :mode
    	t.integer :max_player
    	t.integer :points_award
    	t.datetime :start_time

      t.timestamps
    end
  end
end
