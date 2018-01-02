class CreateBandMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :band_members do |t|
      t.integer :band_id
      t.string :name

      t.timestamps
    end
  end
end
