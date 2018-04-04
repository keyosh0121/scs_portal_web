class RemovePaFromBand < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :pa
  end
end
