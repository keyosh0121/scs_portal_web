class Room < ApplicationRecord
  has_many :room_usages, dependent: :destroy
	has_many :mic_rooms
  has_many :mics

  def self.create_rooms
    Room.create(name:"E1016", room_type:1)
    Room.create(name:"E1116", room_type:1)
    Room.create(name:"会議スペース", room_type:1)
    Room.create(name:"B101", room_type:2)
    Room.create(name:"B102", room_type:2)
    Room.create(name:"B103", room_type:2)
    Room.create(name:"B104", room_type:2)
    Room.create(name:"B105", room_type:2)
    Room.create(name:"B106", room_type:2)
    Room.create(name:"B123", room_type:2)
    Room.create(name:"B126", room_type:2)
    Room.create(name:"キャンセル待ち", room_type:2)
    Room.create(name:"空き部屋なし", room_type:2)
  end

end
