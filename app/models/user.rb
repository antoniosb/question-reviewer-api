class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true
  validates :login, presence: true
end
