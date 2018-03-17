class AddColumnToMicRoom < ActiveRecord::Migration[5.1]
  def change
    add_column :mic_rooms, :room_id, :integer
    add_column :mic_rooms, :period_id, :integer
  end
end
