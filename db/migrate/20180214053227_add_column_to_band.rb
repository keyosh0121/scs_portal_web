class AddColumnToBand < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :type, :integer
  end
end
