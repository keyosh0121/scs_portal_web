class AddApprovalToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :approval, :boolean
  end
end
