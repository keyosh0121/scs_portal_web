class Band < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :members
    add_column :bands, :members, :string, array:true, default: []
  end
end
