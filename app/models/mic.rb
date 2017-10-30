
class MicDateValidator < ActiveModel::Validator
  def validate(record)
    five = Date.today + 5
    if record.date != nil
      if record.date < five
        record.errors[:base] << "マイク練は5日前までの申請のみ可能です"
      end
      if Mic.find_by(band: record.band,date: record.date,time: record.time)
        record.errors[:base] << "すでに同じ時間に申請されています"
      end
    else
      record.errors[:base] << "日付を入力してください"
    end
    if record.full?
      record.errors[:base] << "既にマイク練が3バンド入っています。"
    end
  end
end

class Mic < ApplicationRecord
  validates :band, {presence: true}
  validates_with MicDateValidator
  def full?
    count = Mic.where(date: self.date, time: self.time).count
    if count < 3
      return false
    else
      return true
    end
  end
end
