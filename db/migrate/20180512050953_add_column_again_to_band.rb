class AddColumnAgainToBand < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :website, :string
    add_column :bands, :feature, :text
  end
end
