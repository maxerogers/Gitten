class Following < ActiveRecord::Base
  belongs_to :u, class_name: "User"
  belongs_to :r, class_name: "Repo"
end
