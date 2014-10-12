class RepoTag < ActiveRecord::Base
  belongs_to :repo
  belongs_to :tag
end
