class AddColumnToNotif < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :date, :date
    add_column :notifications, :time, :time
    add_column :notifications, :content, :string
  end
end
