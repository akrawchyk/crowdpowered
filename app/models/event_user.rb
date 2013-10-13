class EventUser < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :event
end