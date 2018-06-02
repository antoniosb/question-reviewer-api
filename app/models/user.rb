class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true
  validates :login, presence: true
  def self.from_token_request request
    login = request.params["auth"] && request.params["auth"]["login"]
    self.find_by login: login
  end
end
