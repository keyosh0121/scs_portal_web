class AddTimeToMic < ActiveRecord::Migration[5.1]
  def change
    add_column :mics, :start_time, :time
    add_column :mics, :end_time, :time
  end
end
