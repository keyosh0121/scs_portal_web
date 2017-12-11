class MicRoomValidator << ActiveModel::Validater
	def validate(record)
		if MicRoom.where(date: record.date).where(time: record.time).any?
			record.errors[:base] << "既に部屋が登録されています"
		end
	end
end

class MicRoom < ApplicationRecord
	validates_with MicRoomValidator
end
