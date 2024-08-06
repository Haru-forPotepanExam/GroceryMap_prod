class Store < ApplicationRecord
  self.primary_key = 'google_place_id'

  has_many :prices, foreign_key: 'google_place_id', primary_key: 'google_place_id'
  has_many :favorites, dependent: :destroy, foreign_key: 'google_place_id', primary_key: 'google_place_id'

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
