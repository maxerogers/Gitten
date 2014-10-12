class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :repo_tags, class_name:"RepoTag"
  has_many :repos, through: :repo_tags
end
