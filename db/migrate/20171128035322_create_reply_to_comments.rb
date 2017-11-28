class CreateReplyToComments < ActiveRecord::Migration[5.1]
  def change
    create_table :reply_to_comments do |t|
      t.integer :type
      t.integer :comment_id
      t.integer :sender_id
      t.text :text

      t.timestamps
    end
  end
end
