class ChangeDatatypeStartEndOfPeriods < ActiveRecord::Migration[5.1]
  def change
    change_column :periods, :start, :string
    change_column :periods, :end, :string
  end
end
