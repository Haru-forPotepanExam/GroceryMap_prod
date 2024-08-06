class AddNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, nill: false
  end
end
