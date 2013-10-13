class AddSuppliesToUsers < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.integer :price
      t.integer :quantity
      t.integer :event_id
      t.timestamps
    end
    add_index :supplies, :event_id
  end
end