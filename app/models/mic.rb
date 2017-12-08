
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
end
