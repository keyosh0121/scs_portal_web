
class MicDateValidator < ActiveModel::Validator
  def validate(record)
		if record.date == nil
			record.errors[:base] << "日付が入力されていません"
		elsif record.date < Date.today + 7
			record.errors[:base] << "7日前を過ぎた日程は申請できません"
		end
		if record.band_id == nil
			record.errors[:base] << "バンドを選択してください"
		end
		if record.period_id == nil
			record.errors[:base] << "時限を入力してください"
		end
  end
end

class Mic < ApplicationRecord
  belongs_to :period
  validates_with MicDateValidator, on: :create
  def full? #マイク練が3件申請されている場合に跳ね返すインスタンスメソッド
    count = Mic.where(date: self.date, time: self.time).count
    if count < 3
      return false
    else
      return true
    end
  end
  def status_string
    if self.status.to_i == 0
      return "未承認"
    elsif self.status.to_i == 1
      return "承認"
    elsif self.status.to_i == 2
      return "条件付きで承認"
    elsif self.status.to_i == 3
      return "不可"
    else
      return ""
    end
  end
  def self.delete_old_records
		self.all.each do |mic|
			if mic.date < Date.today - 100
				mic.delete
			end
		end
  end
end
