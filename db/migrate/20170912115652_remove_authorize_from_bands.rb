class RemoveAuthorizeFromBands < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :authorized, :boolean
  end
end
