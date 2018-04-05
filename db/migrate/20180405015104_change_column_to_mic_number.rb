class ChangeColumnToMicNumber < ActiveRecord::Migration[5.1]
  def change
    def change
    remove_foreign_key :mic_numbers, :bands
    remove_index :mic_numbers, :band_id
    remove_reference :mic_numbers, :band
  end
  end
end
