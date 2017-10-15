
class MicDateValidator < ActiveModel::Validator
  def validate(record)
    five = Date.today + 5
    if record.date != nil
      if record.date <= five
        record.errors[:base] << "マイク練は5日前までの申請のみ可能です"
      end
      if Mic.find_by(band: record.band,date: record.date,time: record.time)
        record.errors[:base] << "すでに同じ時間に申請されています"
      end
    else
      record.errors[:base] << "日付を入力してください"
    end
  end
end

class Mic < ApplicationRecord
  validates :band, {presence: true}
  validates_with MicDateValidator
end
