class AddRoomToRoomUsage < ActiveRecord::Migration[5.1]
  def change
    add_column :room_usages, :room, :string
  end
end
