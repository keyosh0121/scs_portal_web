class AddColumnToMic < ActiveRecord::Migration[5.1]
  def change
    add_column :mics, :period_id, :integer
    add_column :room_usages, :period_id, :integer
  end
end
