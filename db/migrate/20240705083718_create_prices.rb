class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.integer :price_value
      t.float :calculated_value
      t.integer :quantity
      t.integer :weight
      t.text :memo
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :google_place_id, null: false

      t.timestamps
    end
    add_foreign_key :prices, :stores, column: :google_place_id, primary_key: :google_place_id
    add_index :prices, :google_place_id
  end
end
