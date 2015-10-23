class AddCookie < ActiveRecord::Migration
 def change
   add_column :users, :cookie_id, :string
 end

end