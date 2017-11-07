class AddEntryConnectedColumnsToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :able_to_comment?, :boolean
    add_column :events, :entry_required?, :boolean
  end
end
