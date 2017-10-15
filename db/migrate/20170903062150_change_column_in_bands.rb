class ChangeColumnInBands < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :registered?
    add_column :bands, :resistration ,:bool, default: false, null: false
  end
end
