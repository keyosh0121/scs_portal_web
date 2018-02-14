class AddTypeToBandMember < ActiveRecord::Migration[5.1]
  def change
    add_column :band_members, :part, :integer
    add_column :band_members, :user_id, :integer
  end
end
