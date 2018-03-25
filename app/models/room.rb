class Room < ApplicationRecord
  has_many :room_usages, dependent: :destroy
	has_many :mic_rooms
end
