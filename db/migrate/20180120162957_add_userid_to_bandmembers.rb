class AddUseridToBandmembers < ActiveRecord::Migration[5.1]
  def change
    add_column :band_members, :user_id, :integer, after: :band_id
  end
end
