class RemoveColumnFromRoomUsages < ActiveRecord::Migration[5.1]
  def change
    remove_column :room_usages, :time, :time
    remove_column :room_usages, :sender_id, :integer
    remove_column :room_usages, :band, :string
    remove_column :room_usages, :sender, :string
  end
end
