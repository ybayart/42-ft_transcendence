class CreateRooms < ActiveRecord::Migration[6.0]
	def change
		create_table :rooms do |t|
			t.string :name
			t.string :privacy
			t.string :password
			t.references :owner
			t.boolean :dm

			t.timestamps
		end
		add_index :rooms, :name, unique: true
	end
end
