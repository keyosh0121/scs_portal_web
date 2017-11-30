class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :regular_band_id
      t.integer :temporal_band_id
      t.integer :entry_type

      t.timestamps
    end
  end
end
