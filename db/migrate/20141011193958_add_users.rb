class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :user_name
      t.string :password_digest
      t.string :website
      t.string :name
      t.timestamps
    end
  end
end
