class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :sender
      t.string :atevent
      t.string :atcontent
      t.text :comment

      t.timestamps
    end
  end
end
