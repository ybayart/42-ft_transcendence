class CreateCreateBans < ActiveRecord::Migration[6.0]
	def change
		create_table :create_bans do |t|

			t.timestamps
		end
	end
end
