class UpdateVoteDefault < ActiveRecord::Migration
  def change
    change_column_default :images, :total_caption_votes, 0
  end
end
