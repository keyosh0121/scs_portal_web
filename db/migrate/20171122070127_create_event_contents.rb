class CreateEventContents < ActiveRecord::Migration[5.1]
  def change
    create_table :event_contents do |t|
      t.string :name
      t.string :event

      t.timestamps
    end
  end
end
