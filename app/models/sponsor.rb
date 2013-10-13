class Sponsor < ActiveRecord::Base
  # Associations
  has_one :event
end
