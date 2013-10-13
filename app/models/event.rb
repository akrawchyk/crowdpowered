class Event < ActiveRecord::Base
  # Validations
  validates :name, presence: true
  validates :deadline, presence: true
  validates :description, presence: true
  validates :website, presence: false

  # Plugins/Gems
  acts_as_commentable
  acts_as_voteable

  # Associations
  has_many :users, through: :event_users
  has_many :event_users
  has_many :orders
end
