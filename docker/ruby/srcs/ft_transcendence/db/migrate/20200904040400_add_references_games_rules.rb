class AddReferencesGamesRules < ActiveRecord::Migration[6.0]
  def change
    add_reference :games, :game_rules
  end
end
