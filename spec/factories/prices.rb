FactoryBot.define do
  factory :price do
    price_value { 1 }
    calculated_value { 1.5 }
    quantity { 1 }
    weight { 1 }
    memo { "MyText" }
    user { nil }
    product { nil }
    store { nil }
  end
end
