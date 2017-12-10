
class MicDateValidator < ActiveModel::Validator
  def validate(record)
    end
end

class Mic < ApplicationRecord
  validates_with MicDateValidator, on: :create
  def full? #マイク練が3件申請されている場合に跳ね返すクラスメソッド
    count = Mic.where(date: self.date, time: self.time).count
    if count < 3
      return false
    else
      return true
    end
  end
  def status_string
    if self.status == 0
      return "未承認"
    elsif self.status == 1
      return "承認"
    elsif self.status == 2
      return "条件付きで承認"
    elsif self.status == 3
      return "不可"
    else
      return ""
    end
  end
  def delete_old_records
  end
end
