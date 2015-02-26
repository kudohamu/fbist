class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.integer :cost, null: false, limit: 4
      t.timestamps
    end
  end
end
