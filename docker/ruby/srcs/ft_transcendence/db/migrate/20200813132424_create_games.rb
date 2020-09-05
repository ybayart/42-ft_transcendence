class CreateGames < ActiveRecord::Migration[6.0]
	def change
		create_table :games do |t|
			t.references :player1, references: :users
			t.references :player2, references: :users
			t.string :status
			t.integer :player1_pts
			t.integer :player2_pts
			t.references :winner, references: :users
			t.string :mode
			t.references :tournament
			t.datetime :start_time
			t.references :game_rule

			t.timestamps
		end
	end
end
