class CreateBands < ActiveRecord::Migration[5.1]
  def change
    create_table :bands do |t|
      t.string :name
      t.text :members, array: true
      t.string :pa
      t.string :master
      t.integer :year
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
