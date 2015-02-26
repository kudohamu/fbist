class CreateGundams < ActiveRecord::Migration
  def change
    create_table :gundams do |t|
      t.string :icon, null: false
      t.string :name, limit: 45, null: false
      t.integer :no, limit: 6, null: false
      t.string :wiki, limit: 500, null: false
      t.references :cost, null: false
      t.timestamps
    end
  end
end
