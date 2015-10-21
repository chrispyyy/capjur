class Captions < ActiveRecord::Migration
  def change
    create_table :captions do |t|
      t.string :text
      t.integer :total_votes
      t.timestamps null: false
      t.reference :image
      t.reference :user
    end
  end
end
