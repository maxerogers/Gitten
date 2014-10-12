class CreateMeows < ActiveRecord::Migration
  def change
    create_table :mews do |t|
      t.string :message
      t.string :time_string
      t.integer :repo_id
      t.string :author
    end
  end
end
