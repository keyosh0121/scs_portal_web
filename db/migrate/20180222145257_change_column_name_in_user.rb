class ChangeColumnNameInUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :passward_digest, :password_digest
  end
end
