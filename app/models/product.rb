class Product < ApplicationRecord
  validates :title, presence: true
  validates :user, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :user

  scope :filter_by_title, lambda { |keyword|
    where('lower(title) LIKE ?', "%#{keyword.downcase}%")
  }

  scope :above_or_equal_to_price, lambda { |price|
    where('price >= ?', price)
  }

  scope :below_or_equal_to_price, lambda { |price|
    where('price <= ?', price)
  }

  scope :recent, -> { order(:updated_at) }
end
