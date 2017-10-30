class ChangeFormatInRoomUsage < ActiveRecord::Migration[5.1]
  def change
    remove_column :room_usages, :period
    add_column :room_usages, :period, :text
  end
end
