class AddInfoToUsers < ActiveRecord::Migration[6.0]
	def change
		add_column :users, :login, :string
		add_column :users, :provider, :string
		add_index :users, :provider
		add_column :users, :uid, :string
		add_index :users, :uid
		add_column :users, :nickname, :string
		add_column :users, :state, :string, :default => "offline"
		add_column :users, :count_co, :int, :default => 0
	end
end
