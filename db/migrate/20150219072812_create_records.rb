class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :user, null: false
      t.references :gundam, null: false
      t.boolean :won
      t.boolean :free
      t.boolean :ranked
      t.integer :friend_id, limit: 8, null: false, default: 0
      t.timestamps
    end
  end
end
