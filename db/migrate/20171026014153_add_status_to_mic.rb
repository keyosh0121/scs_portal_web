class AddStatusToMic < ActiveRecord::Migration[5.1]
  def change
    add_column :mics, :status, :string
  end
end
