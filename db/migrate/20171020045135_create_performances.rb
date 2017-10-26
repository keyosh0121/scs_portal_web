class CreatePerformances < ActiveRecord::Migration[5.1]
  def change
    create_table :performances do |t|
      t.string :at
      t.text :bands
      t.date :date
      t.boolean :commentable

      t.timestamps
    end
  end
end
