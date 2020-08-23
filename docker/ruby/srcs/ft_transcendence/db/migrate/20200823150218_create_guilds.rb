class CreateGuilds < ActiveRecord::Migration[6.0]
  def change
    create_table :guilds do |t|
      t.string :name
      t.integer :points
      t.string :anagram
      t.references :owner

      t.timestamps
    end
	add_index :guilds, :name, unique: true
	add_index :guilds, :anagram, unique: true
  end
end
