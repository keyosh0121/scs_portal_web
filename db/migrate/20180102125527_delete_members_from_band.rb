class DeleteMembersFromBand < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :members
  end
end
