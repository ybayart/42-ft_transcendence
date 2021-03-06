class CreateTournaments < ActiveRecord::Migration[6.0]
	def change
		create_table :tournaments do |t|
			t.string :mode
			t.integer :max_player
			t.integer :points_award
			t.datetime :start_time
			t.references :winner, references: :users
			t.string :status

			t.timestamps
		end
	end
end
