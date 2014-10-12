class Repo < ActiveRecord::Base
  belongs_to :user
  has_many :repo_tags
  has_many :mews
end
