class CreateMicRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :mic_rooms do |t|

      t.timestamps
    end
  end
end
