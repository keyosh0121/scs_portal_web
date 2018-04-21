class AddRemarkToMic < ActiveRecord::Migration[5.1]
  def change
    add_column :mics, :remark, :text
  end
end
