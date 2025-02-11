class AddUsageStatsToGenerations < ActiveRecord::Migration[8.0]
  def change
    add_column :generations, :view_count, :integer, default: 0
    add_column :generations, :like_count, :integer, default: 0
  end
end
