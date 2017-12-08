class ChangeColumnInMicRoom < ActiveRecord::Migration[5.1]
  def change
    change_column :mic_rooms, :time, :string
  end
end
