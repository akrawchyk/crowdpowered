class AddCreditCardToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :credit_card_id, :string
    add_column :orders, :credit_card_description, :string
  end
end
