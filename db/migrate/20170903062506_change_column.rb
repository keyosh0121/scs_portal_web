class ChangeColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :bands, :resistration
    add_column :bands, :registration, :boolean, default: false, null: false
  end
end
