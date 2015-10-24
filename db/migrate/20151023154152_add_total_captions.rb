class AddTotalCaptions < ActiveRecord::Migration

 def change
   add_column :images, :total_caption_votes, :integer, :default => 0
 end
end
