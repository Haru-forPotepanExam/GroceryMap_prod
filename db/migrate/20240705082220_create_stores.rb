class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores, id: false do |t|
      t.string :google_place_id, null: false, primary_key: true
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
