class AddMaxUnansweredInWarTime < ActiveRecord::Migration[6.0]
  def change
    add_column :war_times, :max_unanswered, :integer, default: 0
  end
end
