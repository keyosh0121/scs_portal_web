class AddAllToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :name, :string
    add_column :events, :date, :date
  end
end
