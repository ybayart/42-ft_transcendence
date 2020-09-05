class CreateGameRules < ActiveRecord::Migration[6.0]
  def change
    create_table :game_rules do |t|
      t.integer :canvas_width, default: 600
      t.integer :canvas_height, default: 400
      t.integer :ball_radius, default: 10
      t.integer :ball_speed, default: 4
      t.integer :max_points, default: 5
      t.timestamps
    end
  end
end
