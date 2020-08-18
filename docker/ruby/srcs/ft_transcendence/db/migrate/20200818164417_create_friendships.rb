class CreateFriendships < ActiveRecord::Migration[6.0]
	def change
		create_table :friendships, id: false do |t|
			t.references :friend_a, references: :users, foreign_key: { to_table: :users}
			t.references :friend_b, references: :users, foreign_key: { to_table: :users}
		end
	end
end
