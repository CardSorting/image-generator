class AddMetadataToGenerations < ActiveRecord::Migration[7.1]
  def change
    add_column :generations, :metadata, :jsonb
    add_column :generations, :generation_time, :float
  end
end
