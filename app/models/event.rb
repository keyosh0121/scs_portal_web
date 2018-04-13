class EventValidator < ActiveModel::Validator
  def validate(record)
    if record.name == nil
      record.errors[:base] << "イベント名が入力されていません"
    end
    if record.date == nil
      record.errors[:base] << "日付が入力されていません"
    end
    if record.start_time == nil
      record.errors[:base] << "時間が指定されていません"
    end
  end
end

class Event < ApplicationRecord
  has_many :event_contents, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :bands
  validates_with EventValidator
end
