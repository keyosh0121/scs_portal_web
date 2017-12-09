class StatusIntegerChange < ActiveRecord::Migration[5.1]
  def change
    change_column :mics, :status, :integer
  end
end
