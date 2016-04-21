class CreateWebpageAssessors < ActiveRecord::Migration
  def change
    create_table :webpage_assessors do |t|
      t.string :email
      t.string :url

      t.timestamps null: false
    end
  end
end
