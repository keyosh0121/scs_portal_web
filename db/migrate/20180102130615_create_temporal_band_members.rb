class CreateTemporalBandMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :temporal_band_members do |t|
      t.integer :band_id
      t.string :name

      t.timestamps
    end
  end
end
