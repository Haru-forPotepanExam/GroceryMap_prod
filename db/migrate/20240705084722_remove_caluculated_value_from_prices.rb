class RemoveCaluculatedValueFromPrices < ActiveRecord::Migration[6.1]
  def change
    remove_column :prices, :calculated_value, :float
  end
end
