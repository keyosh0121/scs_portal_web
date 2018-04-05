class RemoveColumnFromBandMember < ActiveRecord::Migration[5.1]
  def change
    remove_column :band_members, :part, :integer
  end
end
