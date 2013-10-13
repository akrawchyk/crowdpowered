class AddZipCodeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :zipcode, :integer
  end
end
