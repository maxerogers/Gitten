class AddFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.belongs_to :r
      t.belongs_to :u
      t.timestamps
    end
  end
end
