class AddColumnToMics < ActiveRecord::Migration[5.1]
  def change
    add_column :mics, :user_id, :integer
  end
end
