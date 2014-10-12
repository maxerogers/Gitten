class User < ActiveRecord::Base
  include BCrypt
  #validates_uniqueness_of :user_name, :email
  has_secure_password
  has_many :repos
  has_many :followings, foreign_key: "u_id"
  has_many :rs, through: :followings #these are the repos that you are following
end
