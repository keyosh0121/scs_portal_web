class AddReservationTypeNumToMicRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :mic_rooms, :reservation_type_num, :integer
  end
end
