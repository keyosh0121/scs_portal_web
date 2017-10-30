class CreateRoomUsages < ActiveRecord::Migration[5.1]
  def change
    create_table :room_usages do |t|
      t.string :band
      t.string :sender
      t.date :date
      t.integer :period
      t.time :time

      t.timestamps
    end
  end
end
