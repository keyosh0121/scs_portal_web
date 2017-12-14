class AddColumnToEntry < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :musics, :string
    add_column :entries, :times, :string
  end
end
