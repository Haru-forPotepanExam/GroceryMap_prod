class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.string :google_place_id, null: false

      t.timestamps
    end
    add_foreign_key :favorites, :stores, column: :google_place_id, primary_key: :google_place_id
    add_index :favorites, :google_place_id
  end
end
