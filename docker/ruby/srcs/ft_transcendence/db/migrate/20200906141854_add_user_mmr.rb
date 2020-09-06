class AddUserMmr < ActiveRecord::Migration[6.0]
  def change
	add_column :users, :mmr, :integer, default: 1000
  end
end
