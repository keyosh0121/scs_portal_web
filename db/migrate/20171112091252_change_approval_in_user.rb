class ChangeApprovalInUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :approval
    add_column :users, :approval, :boolean, default: false
  end
end
