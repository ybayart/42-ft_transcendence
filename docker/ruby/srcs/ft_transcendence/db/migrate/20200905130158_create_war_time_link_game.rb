class CreateWarTimeLinkGame < ActiveRecord::Migration[6.0]
  def change
    create_table :war_time_link_games do |t|
      t.belongs_to :war_time, index: true
      t.belongs_to :game, index: true
    end
  end
end
