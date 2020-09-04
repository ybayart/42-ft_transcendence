class CreateWars < ActiveRecord::Migration[6.0]
  def change
    create_table :wars do |t|
      t.references :guild1
      t.references :guild2
      t.datetime :start_at
      t.datetime :end_at
      t.integer :points_to_win
      t.integer :points1
      t.integer :points2
      t.string :state
      t.boolean :all_match
      t.references :winner

      t.timestamps
    end
  end
end
