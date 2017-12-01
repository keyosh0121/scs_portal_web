class AddMessageToEntry < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :message, :text
  end
end
