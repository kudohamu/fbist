class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :no, limit: 6, null: false
      t.string :rank, null: false
      t.timestamps
    end
  end
end
