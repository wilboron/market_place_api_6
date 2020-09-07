class Order < ApplicationRecord
  before_validation :set_total!
  belongs_to :user
  validates :user, presence: true

  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  def set_total!
    self.total = products.sum(&:price)
  end
end
