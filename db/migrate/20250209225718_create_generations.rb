class CreateGenerations < ActiveRecord::Migration[8.0]
  def change
    create_table :generations do |t|
      t.references :user, null: false, foreign_key: true
      t.text :prompt
      t.string :style
      t.string :size
      t.string :status
      t.string :image_url
      t.text :error_message

      t.timestamps
    end
  end
end
