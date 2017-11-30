class AddTypeToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :type, :integer
  end
end
