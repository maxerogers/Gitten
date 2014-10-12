class Repo < ActiveRecord::Base
  belongs_to :user
  has_many :repo_tags
  has_many :mews
  has_many :followings, foreign_key: "r_id"
  has_many :us, through: :followings #These are the users that are following you
end
