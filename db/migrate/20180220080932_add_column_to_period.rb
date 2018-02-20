class AddColumnToPeriod < ActiveRecord::Migration[5.1]
  def change
    add_column :periods, :name, :string
    add_column :periods, :start, :time
    add_column :periods, :end, :time
  end
end
