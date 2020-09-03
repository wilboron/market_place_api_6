class User < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /@/
  has_secure_password
end
