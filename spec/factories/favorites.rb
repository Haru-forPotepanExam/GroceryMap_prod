FactoryBot.define do
  factory :favorite do
    association :user
    sequence(:google_place_id) { |n| "google_place_id#{n}" }
  end
end
