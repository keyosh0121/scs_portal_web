
require 'csv'

CSV.generate do |csv|
  csv_column_names = ["エントリー送信者","送信者アドレス","送信者電話番号","バンド名","バンドメンバー","バンマス","メッセージ"]
  csv << csv_column_names
  @entries.each do |entry|
	user = User.find(entry.user_id)
	if entry.entry_type == 0 #個人エントリーの場合
		band = Band.new
	elsif entry.entry_type == 1 #正規バンドのみ
		band = Band.find(entry.regular_band_id)
		master = band.master
	elsif entry.entry_type == 2 #企画バンドのみ
		band = TemporalBand.find(entry.temporal_band_id)
		master = nil
	elsif entry.entry_type == 3 #両方可
		if entry.temporal_band_id
			band = TemporalBand.find(entry.temporal_band_id)
			master =nil
		else
			band = Band.find(entry.regular_band_id)
			master = band.master
		end
	end
    csv_column_values = [
      user.name,
      user.email,
      user.tel,
			band.name,
			band.members,
			master,
			entry.message
    ]
    csv << csv_column_values
  end
end
