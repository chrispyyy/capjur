class InitializeVotes < ActiveRecord::Migration
  def change
    change_column_default :captions, :total_votes, 0
  end
end