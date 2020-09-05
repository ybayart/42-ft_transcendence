class CreateWarTime < ActiveRecord::Migration[6.0]
	def change
		create_table :war_times do |t|
			t.references :war
			t.datetime :start_at
			t.datetime :end_at
			t.integer :max_unsanswered

			t.timestamps
		end
	end
end
