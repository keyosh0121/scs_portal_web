class AddColumnToMicRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :mic_rooms, :room, :string
    add_column :mic_rooms, :date, :date
    add_column :mic_rooms, :time, :time
  end
end
