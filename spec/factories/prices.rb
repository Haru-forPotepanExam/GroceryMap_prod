FactoryBot.define do
  factory :price do
    price_value { 1 }
    quantity { 1 }
    weight { 100 }
    memo { "MyText" }
    user_id { 1 }
    product_id { 1 }
    google_place_id { "google_place_id1" }
  end
end
