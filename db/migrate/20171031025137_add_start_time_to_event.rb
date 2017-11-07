class AddStartTimeToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :start_time, :time
  end
end
