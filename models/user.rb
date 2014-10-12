class User < ActiveRecord::Base
  include BCrypt
  validates_uniqueness_of :user_name, :email
  has_secure_password
end
