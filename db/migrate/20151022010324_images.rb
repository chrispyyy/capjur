class Images < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :caption
      t.string :url
      t.timestamps null: false
    end
  end
end
