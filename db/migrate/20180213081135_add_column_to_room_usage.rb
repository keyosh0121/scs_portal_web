class AddColumnToRoomUsage < ActiveRecord::Migration[5.1]
  def change
    add_column :room_usages, :band_id, :integer
    add_column :room_usages, :sender_id, :integer
  end
end
