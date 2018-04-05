class AddColumnToBandMember < ActiveRecord::Migration[5.1]
  def change
    add_column :band_members, :mic_number, :integer
  end
end
