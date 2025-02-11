class AddSocialMetricsToGenerations < ActiveRecord::Migration[8.0]
  def change
    add_column :generations, :views_count, :integer, default: 0, null: false
    add_column :generations, :likes_count, :integer, default: 0, null: false
    add_column :generations, :bookmarks_count, :integer, default: 0, null: false
    add_column :generations, :shares_count, :integer, default: 0, null: false
    add_column :generations, :engagement_rate, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :generations, :trending_score, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :generations, :last_engagement_at, :datetime

    add_index :generations, :views_count
    add_index :generations, :likes_count
    add_index :generations, :trending_score
    add_index :generations, [:style, :trending_score]
  end
end
