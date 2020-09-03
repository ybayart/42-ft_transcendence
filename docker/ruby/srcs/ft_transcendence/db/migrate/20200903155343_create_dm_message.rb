class CreateDmMessage < ActiveRecord::Migration[6.0]
	def change
		create_table :dm_messages do |t|
			t.references :dm, null: false
			t.references :user, null: false
			t.string :message
			
			t.timestamps
		end
	end
end
