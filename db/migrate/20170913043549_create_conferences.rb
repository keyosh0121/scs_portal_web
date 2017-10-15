class CreateConferences < ActiveRecord::Migration[5.1]
  def change
    create_table :conferences do |t|
      t.string :name
      t.date :date
      t.text :contents
      t.boolean :commentable
      t.timestamps
    end
  end
end
