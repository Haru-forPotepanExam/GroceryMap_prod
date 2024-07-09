class Product < ApplicationRecord
  belongs_to :category

  has_many :prices

  validates :name, uniqueness: true, presence: true

  scope :latest_price, -> { order(:created_at).limit(1) }

  def self.ransackable_attributes(auth_object = nil)
    %w[category_id created_at id name updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "prices"]
  end
end
