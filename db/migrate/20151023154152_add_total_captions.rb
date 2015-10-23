class AddTotalCaptions < ActiveRecord::Migration
 
 def change
   add_column :images, :total_caption_votes, :interger
 end

end