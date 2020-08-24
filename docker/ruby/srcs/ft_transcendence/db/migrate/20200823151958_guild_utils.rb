class GuildUtils < ActiveRecord::Migration[6.0]
	def change
		create_table :guild_link_officers, id: false do |t|
			t.belongs_to :guild, index: true
			t.belongs_to :user, index: true
		end
	end
end
