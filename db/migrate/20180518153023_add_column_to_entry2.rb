class AddColumnToEntry2 < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :remark, :text
  end
end
