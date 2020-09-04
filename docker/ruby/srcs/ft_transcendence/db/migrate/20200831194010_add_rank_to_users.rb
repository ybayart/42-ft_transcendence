class AddRankToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :rank, :integer, default: 5
  end
end
