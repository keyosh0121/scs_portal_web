class CreateTemporalBands < ActiveRecord::Migration[5.1]
  def change
    create_table :temporal_bands do |t|
      t.string :name
      t.text :members
      t.string :event
      t.string :music
      t.time :time

      t.timestamps
    end
  end
end
