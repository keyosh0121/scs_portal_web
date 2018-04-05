class DropMicNumber < ActiveRecord::Migration[5.1]
  def change
    drop_table :mic_numbers
  end
end
