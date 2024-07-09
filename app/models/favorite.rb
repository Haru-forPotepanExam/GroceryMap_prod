class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :store, primary_key: 'google_place_id', foreign_key: 'google_place_id'
end
