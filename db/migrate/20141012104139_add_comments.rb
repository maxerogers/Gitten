class AddComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :message
      t.belongs_to :user
      t.belongs_to :repo
    end
  end
end
