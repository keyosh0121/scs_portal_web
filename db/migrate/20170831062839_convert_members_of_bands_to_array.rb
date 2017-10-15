class ConvertMembersOfBandsToArray < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :members
    add_column :bands, :members, :text, default: [].to_yaml, array:true
  end
end
