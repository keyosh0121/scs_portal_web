class EditColumnForComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :event_content_id, :integer
    remove_column :comments, :content_id, :integer
  end
end
