class GuildUtils < ActiveRecord::Migration[6.0]
	def change
		create_table :guild_link_officers, id: false do |t|
			t.belongs_to :guild, index: true
			t.belongs_to :user, index: true
		end
		create_table :guild_invit_members do |t|
			t.references :guild
			t.references :by, references: :users, foreign_key: { to_table: :users}
			t.references :user
			t.string :state

			t.timestamps
		end
	end
end
