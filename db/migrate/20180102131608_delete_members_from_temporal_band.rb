class DeleteMembersFromTemporalBand < ActiveRecord::Migration[5.1]
  def change
    remove_column :temporal_bands, :members
  end
end
