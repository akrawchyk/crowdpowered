class AddSponsorModel < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.integer :event_id
      t.string :name
    end
  end
end
