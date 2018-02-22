class EditColumnComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :user_id, :integer
    remove_column :comments, :sender_id, :integer
  end
end
