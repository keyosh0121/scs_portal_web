class Period < ApplicationRecord
  has_many :mics
  def self.create_periods
    Period.create(name: "0限", start: "8:00", end: "9:00")
    Period.create(name: "1限", start: "9:00", end: "10:30")
    Period.create(name: "2限", start: "10:40", end: "12:10")
    Period.create(name: "昼限", start: "12:10", end: "13:00")
    Period.create(name: "3限", start: "13:00", end: "14:30")
    Period.create(name: "4限", start: "14:45", end: "16:15")
    Period.create(name: "5限", start: "16:30", end: "18:00")
    Period.create(name: "6限", start: "18:15", end: "19:45")
    Period.create(name: "7限", start: "19:55", end: "21:30")
  end
  #if calculation needed, use parse and "tod" gem
end



