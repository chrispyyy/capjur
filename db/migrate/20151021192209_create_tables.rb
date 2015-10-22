class CreateTables < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string     :url
      t.timestamps 
    end

    create_table :users do |t|
      t.string     :name
      t.timestamps 
    end

    create_table :votes do |t|
      t.references :caption
      t.references :user
      t.timestamps 
    end
    
    create_table :captions do |t|
      t.references :image
      t.references :user
      t.string     :text
      t.integer    :total_votes
      t.timestamps 
    end
  end
end