class User < ApplicationRecord
  has_many :prices
  has_many :favorites, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :confirmable, :timeoutable

  validates :email, uniqueness: true
  validates :name, uniqueness: true, presence: true
end
