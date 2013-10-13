class Event < ActiveRecord::Base
  geocoded_by :zipcode
  after_validation :geocode

  # Validations
  validates :name, presence: true
  validates :deadline, presence: true
  validates :description, presence: true
  validates :website, presence: false
  validates :zipcode, presence: true

  # Plugins/Gems
  acts_as_commentable
  acts_as_voteable

  # Associations
  has_many :users, through: :event_users
  has_many :event_users
  has_many :orders
end
