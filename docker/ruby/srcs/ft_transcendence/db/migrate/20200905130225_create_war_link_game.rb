class CreateWarLinkGame < ActiveRecord::Migration[6.0]
  def change
    create_table :war_link_games do |t|
      t.belongs_to :war, index: true
      t.belongs_to :game, index: true
    end
  end
end
