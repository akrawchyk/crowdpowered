require 'valid_email'
class User < ActiveRecord::Base
  # Validations
  #include ActiveModel::Validations
  validates :name, presence: true, :email => true

  # Plugins/Gems
  acts_as_voter
end
