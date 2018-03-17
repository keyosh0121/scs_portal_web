class DeleteColumnFromMicRoom < ActiveRecord::Migration[5.1]
  def change
    remove_column :mic_rooms, :room
    remove_column :mic_rooms, :time
  end
end
