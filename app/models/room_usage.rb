class RoomUsageValidator < ActiveModel::Validator
  def validate(record)
    if record.band_id == nil
      record.errors[:base] << "バンド名が入力されていません"
    end
    if record.room == nil
      record.errors[:base] << "部屋が選択されていません"
    end
    if record.date == nil
      record.errors[:base] << "日付を選択してください"
    end
    if record.period == nil
      record.errors[:base] << "時限を選択してください"
    end
  end
end

class RoomUsage < ApplicationRecord
  belongs_to :user
  belongs_to :band
  belongs_to :period
  serialize :period
  validates_with RoomUsageValidator
  def self.delete_old_records
    one_year_ago = Date.today - 365
    self.where("date < one_year_ago").delete_all
  end
	def user
		User.find(self.user_id)
	end
end
