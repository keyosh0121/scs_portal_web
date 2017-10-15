class AddColumnToBands < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :registered?, :boolean
  end
end
