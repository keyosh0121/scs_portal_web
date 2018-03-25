class AddColumnToMoMic < ActiveRecord::Migration[5.1]
  def change
    add_column :mics, :order, :integer
  end
end
