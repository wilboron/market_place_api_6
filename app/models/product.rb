class Product < ApplicationRecord
  validates :title, presence: true
  validates :user, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :user
end
