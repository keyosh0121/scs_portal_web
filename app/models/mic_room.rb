
class MicRoom < ApplicationRecord
  validates :room_id, presence: {message: '部屋が選択されていません'}
  def reservation_type
    if self.reservation_type_num

      if self.reservation_type_num == 0
        return "当日予約"
      elsif self.reservation_type_num == 1
        return "週予約"
      elsif self.reservation_type_num == 2
        return "月予約"
      else
        return "不明"
      end

    else
      return "不明"
    end
  end
end
