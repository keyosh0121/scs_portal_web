class AddColumnToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :datetime, :date_time
  end
end
