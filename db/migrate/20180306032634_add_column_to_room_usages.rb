class AddColumnToRoomUsages < ActiveRecord::Migration[5.1]
  def change
    add_column :room_usages, :room_id, :integer
  end
end
