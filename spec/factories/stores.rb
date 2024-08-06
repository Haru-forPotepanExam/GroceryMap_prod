FactoryBot.define do
  factory :store do
    sequence(:google_place_id) { |n| "google_place_id#{n}" }
    sequence(:name) { |n| "store#{n}" }
  end
end
