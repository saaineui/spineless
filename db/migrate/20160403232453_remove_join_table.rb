class RemoveJoinTable < ActiveRecord::Migration
  def change
	  drop_table :bookmarks_users
	  change_table :bookmarks do |t|
		t.rename :percent, :scroll
		t.integer :user_id
	  end
	  
 	  add_index :bookmarks, :user_id
  end
end
