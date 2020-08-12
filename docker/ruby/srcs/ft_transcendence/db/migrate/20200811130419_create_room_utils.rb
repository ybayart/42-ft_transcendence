class CreateRoomUtils < ActiveRecord::Migration[6.0]
	def change
		create_table :room_bans do |t|
			t.references :user
			t.references :by, references: :users, foreign_key: { to_table: :users}
			t.references :room
			t.datetime :end_at

			t.timestamps
		end
		create_table :room_mutes do |t|
			t.references :user
			t.references :room
			t.references :by, references: :users, foreign_key: { to_table: :users}
			t.datetime :end_at

			t.timestamps
		end
	end
end
