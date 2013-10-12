require 'valid_email'
class User < ActiveRecord::Base
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  #include ActiveModel::Validations
  validates :email, presence: true, :email => true
  validates :phone_number, presence: true
  validates :zipcode, presence: true

  # Plugins/Gems
  acts_as_voter
end
