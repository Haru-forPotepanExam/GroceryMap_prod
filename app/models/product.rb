class Product < ApplicationRecord
  belongs_to :category

  has_many :prices

  validates :name, uniqueness: true, presence: true

  def self.ransackable_attributes(options = {})
    %w(category_id created_at id name updated_at)
  end

  def self.ransackable_associations(options = {})
    ["category", "prices"]
  end
end
