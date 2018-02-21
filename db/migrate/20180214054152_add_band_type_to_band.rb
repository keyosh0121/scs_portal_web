class AddBandTypeToBand < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :band_type, :integer
    remove_column :bands, :type
  end
end
