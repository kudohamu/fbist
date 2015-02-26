class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :user, null: false
      t.references :gundam, null: false
      t.boolean :won
      t.timestamps
    end
  end
end
