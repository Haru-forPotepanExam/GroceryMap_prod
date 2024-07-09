require 'csv'

namespace :import do
  desc "Import products from csv"

  task products: :environment do
    path = File.join(Rails.root, "db/csv/products_data.csv")
    puts "path: #{path}"
    list = []
    CSV.foreach(path, headers: true) do |row|
      list << {
        name: row["name"],
        category_id: row["category_id"],
      }
    end
    puts "start to create products data"
    begin
      Product.create!(list)
      puts "completed!!"
    rescue ActiveModel::UnknownAttributeError => invalid
      puts "raised error : unknown attribute"
    end
  end
end
