class DefaultValueGameRules < ActiveRecord::Migration[6.0]
  def change
    change_column_default :game_rules, :canvas_width, 600
    change_column_default :game_rules, :canvas_height, 400
    change_column_default :game_rules, :ball_radius, 10
    change_column_default :game_rules, :ball_speed, 4
  end
end
