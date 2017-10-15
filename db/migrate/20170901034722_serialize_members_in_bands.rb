class SerializeMembersInBands < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :members
    add_column :bands, :members, :text, array: true
  end
end
