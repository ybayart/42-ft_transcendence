class CreateDms < ActiveRecord::Migration[6.0]
	def change
		create_table :dms do |t|
			t.references :user1, references: :users
			t.references :user2, references: :users

			t.timestamps
		end
	end
end
