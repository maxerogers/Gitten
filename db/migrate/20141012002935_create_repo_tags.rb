class CreateRepoTags < ActiveRecord::Migration
  def change
    create_table :repo_tags do |t|
      t.integer :repo_id
      t.integer :tag_id
      t.timestamps
    end
  end
end
