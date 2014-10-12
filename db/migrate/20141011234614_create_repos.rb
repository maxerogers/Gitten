class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :title
      t.string :date_location
      t.string :demo_link
      t.string :repo_link
      t.text :blurb
      t.integer :user_id
      t.timestamps
    end
  end
end
