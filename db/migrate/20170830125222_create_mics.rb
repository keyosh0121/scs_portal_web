class CreateMics < ActiveRecord::Migration[5.1]
  def change
    create_table :mics do |t|
      t.string :band
      t.string :pa
      t.string :paattendance
      t.string :sender
      t.date :date
      t.string :time
      t.string :approval
      t.timestamps
    end
  end
end
