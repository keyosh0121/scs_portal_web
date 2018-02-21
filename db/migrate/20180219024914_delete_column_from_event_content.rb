class DeleteColumnFromEventContent < ActiveRecord::Migration[5.1]
  def change
    remove_column :event_contents, :event, :string
  end
end
