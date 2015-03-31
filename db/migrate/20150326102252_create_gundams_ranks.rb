class CreateGundamsRanks < ActiveRecord::Migration
  def change
    create_table :gundams_ranks do |t|
      t.references :gundam, null: false
      t.references :rank, null: false
      t.timestamps
    end
  end
end
