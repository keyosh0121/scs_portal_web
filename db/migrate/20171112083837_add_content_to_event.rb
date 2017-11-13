class AddContentToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :contents, :text
  end
end
