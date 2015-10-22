class Captions < ActiveRecord::Migration
  def change
    create_table :captions do |t|
      t.references :image
      t.references :user
      t.string :text
      t.integer :total_votes
      t.timestamps null: false
    end
  end
end
