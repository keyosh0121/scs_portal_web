class ModifyMicColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :mics, :room_id, :integer
    remove_column :mics, :band
    remove_column :mics, :pa
    remove_column :mics, :sender
    remove_column :mics, :time
    remove_column :mics, :approval
  end
end
