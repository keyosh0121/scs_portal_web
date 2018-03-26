class RemoveMasterFromBand < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :master
  end
end
