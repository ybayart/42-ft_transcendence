class CreateMuteships < ActiveRecord::Migration[6.0]
	def change
		create_table :muteships, id: false do |t|
			t.references :user
			t.references :muted, references: :users
		end
	end
end
