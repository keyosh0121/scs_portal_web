class ChangeBooleanColumnsInEvent < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :able_to_comment?
    remove_column :events, :entry_required?
    add_column :events, :able_to_comment?, :boolean, default: false, null: false
    add_column :events, :entry_required?, :boolean, default: false, null: false
  end
end
