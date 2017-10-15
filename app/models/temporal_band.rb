class TemporalBand < ApplicationRecord
  serialize :members
  validates :name, presence: true
  validates :event, presence: true
end
