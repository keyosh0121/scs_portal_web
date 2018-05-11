class AddApplicantToRoomUsage < ActiveRecord::Migration[5.1]
  def change
    add_column :room_usages, :applicant, :string
  end
end
