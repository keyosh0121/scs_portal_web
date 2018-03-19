class Room < ApplicationRecord
  has_many :room_usages, dependent: :destroy
end
