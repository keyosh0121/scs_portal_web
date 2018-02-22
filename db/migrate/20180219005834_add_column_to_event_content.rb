class AddColumnToEventContent < ActiveRecord::Migration[5.1]
  def change
    add_column :event_contents, :event_id, :integer
  end
end
