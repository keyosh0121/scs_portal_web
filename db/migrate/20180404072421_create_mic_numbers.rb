class CreateMicNumbers < ActiveRecord::Migration[5.1]
  def change
    create_table :mic_numbers do |t|
      t.integer :mic_number
      t.references :band, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end
