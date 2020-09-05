class CreateTournamentsUsersJoinTable < ActiveRecord::Migration[6.0]
  def change
      create_table :tournaments_users, id: false do |t|
      t.bigint :tournament_id
      t.bigint :user_id
    end
 
    add_index :tournaments_users, :tournament_id
    add_index :tournaments_users, :user_id
  end
end
