class AddEventToBand < ActiveRecord::Migration[5.1]
  def change
    add_column :bands, :event_id, :integer
  end
end
