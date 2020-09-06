class AddUnansweredInWarTime < ActiveRecord::Migration[6.0]
  def change
    add_column :war_times, :unanswered, :integer, default: 0
  end
end
