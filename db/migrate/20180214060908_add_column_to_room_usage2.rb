class AddColumnToRoomUsage2 < ActiveRecord::Migration[5.1]
  def change
    add_column :room_usages, :user_id, :integer
  end
end
