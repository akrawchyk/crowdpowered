class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :phone_number
      t.string :twitter_handle
      t.string :facebook_handle
      t.integer :zipcode

      t.timestamps
    end
  end
end
