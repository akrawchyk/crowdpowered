class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :deadline
      t.text :description
      t.text :website
      t.text :properties

      t.timestamps
    end
  end
end
