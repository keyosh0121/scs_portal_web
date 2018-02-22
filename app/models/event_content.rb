class EventContent < ApplicationRecord
  belongs_to :event
  has_many :comments
end
