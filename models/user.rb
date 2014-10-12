class User < ActiveRecord::Base
  include BCrypt
  has_secure_password
  has_many :repos
end
