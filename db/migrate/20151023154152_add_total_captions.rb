class AddTotalCaptions < ActiveRecord::Migration
 
 def change
   add_column :images, :total_caption_votes, :integer, 0
 end

end