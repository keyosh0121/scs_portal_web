
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
    if Mic.where(date:record.date).where(period_id:record.period_id).count == 3
      record.errors[:base] << "その時限にはすでに3バンド申請されています。"
    end
  end
end

class Mic < ApplicationRecord
  belongs_to :band
  belongs_to :period
  belongs_to :user
  belongs_to :room, optional: true
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
  def self.daily_split_query
    date = Date.today+2
    today_mics = Mic.where(date: date)
    if today_mics.any?
      Period.all.each do |p|
        if today_mics.where(period_id: p).any?
          if today_mics.where(period_id: p).count >= 2
            mics_on_period = today_mics.where(period_id: p).order(:created_at)
            first_mic = mics_on_period.first
            MicMailer.send_mic_split_query(mics_on_period,first_mic).deliver
          end
        end
      end
    end
  end

  def mic_room_text(room_id)
    if room_id != "選択してください"
      former_room_id = self.room_id
      self.update(room_id: room_id)
      if self.room_id == former_room_id
        return ""
      elsif self.room.name == "キャンセル待ち"
        return "只今キャンセル待ちとなっております。部屋が分かり次第追ってご連絡させていただきます。また、部屋が取れずマイク練ができないことも考えられますので、ご了承ください。\n"
      elsif self.room.name == "空き部屋なし"
        return "本日のマイク練ですが、空き部屋がないため、行うことができません。申し訳ありません。\n"
      elsif former_room_id == nil
        return "本日のマイク練は#{self.room.name}にて行います。\n"
      elsif self.room_id != former_room_id
        return "マイク練部屋に変更がありました。#{self.room.name}にて行います。\n"
      else
        return ""
      end
    else
      return ""
    end
  end

  def mic_split_order_text(order)
    if order == nil
      return ""
    end
    if self.order != order.to_i
      self.update(order: order.to_i)
      return "諸事情により、分割の順番が変更されました。#{self.band.name}さんは#{self.order}番目となります。\n"
    else
      return "本日の分割は#{self.order}番目です。\n"
    end
  end

  def overlapped_mics
    Mic.order(:created_at).select {|m| m.id != self.id && m.date == self.date && m.period_id == self.period_id}
  end
end
