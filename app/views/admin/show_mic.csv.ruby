require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(Band Pa Attendance Date Time Status)
  csv << csv_column_names
  @mics.each do |mic|
    csv_column_values = [
      mic.band,
      mic.pa,
      mic.paattendance,
      mic.date,
      mic.time,
      mic.status
    ]
    csv << csv_column_values
  end
end
