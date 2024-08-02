FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    category_id { 1 }
  end
end
