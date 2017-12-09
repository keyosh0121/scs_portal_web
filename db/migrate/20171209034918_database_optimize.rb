class DatabaseOptimize < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :event_id, :integer
    add_column :mics, :band_id, :integer
  end
end
