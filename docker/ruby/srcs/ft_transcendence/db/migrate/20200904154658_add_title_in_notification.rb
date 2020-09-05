class AddTitleInNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :title, :string
    add_column :notifications, :readed, :boolean
  end
end
