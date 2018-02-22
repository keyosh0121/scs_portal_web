class AddColumnToComment < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :content_id, :integer
    add_column :comments, :reply_to, :integer
    add_column :comments, :sender_id, :integer
  end
end
