class AddPaIdToBand < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :pa_id, :integer
  end
end
