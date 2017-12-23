class MicRoomValidator < ActiveModel::Validator
	def validate(record)
		if MicRoom.where(date: record.date).where(time: record.time).any?
			record.errors[:base] << "既に部屋が登録されています"
		end
	end
end

class MicRoom < ApplicationRecord
	validates_with MicRoomValidator
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
