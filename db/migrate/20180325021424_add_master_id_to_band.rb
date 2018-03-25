class AddMasterIdToBand < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :master_id, :integer
  end
end
