class RoomUsage < ApplicationRecord
  serialize :period
  validates :date,  uniquness: { scope: [:period, :room]  }
	def self.delete_old_records
		one_year_ago = Date.today - 365
		self.where("date < one_year_ago").delete_all
	end
end
