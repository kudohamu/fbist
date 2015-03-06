class CreateFriendLists < ActiveRecord::Migration
  def change
    create_table :friend_lists do |t|
      t.integer :from_user_id, null: false, limit: 8
      t.integer :to_user_id, null: false, limit: 8
      t.timestamps
    end
  end
end
