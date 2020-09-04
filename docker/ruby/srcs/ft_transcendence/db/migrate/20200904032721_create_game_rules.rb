class CreateGameRules < ActiveRecord::Migration[6.0]
  def change
    create_table :game_rules do |t|
      t.integer :canvas_width
      t.integer :canvas_height
      t.integer :ball_radius
      t.integer :ball_speed
      t.timestamps
    end
  end
end
