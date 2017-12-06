class EntryValidator < ActiveModel::Validator
  def validate(record)
    if record.event_id == nil || record.user_id == nil || record.entry_type == nil
      record.errors[:base] << "未入力の項目があります"
    end
    if record.entry_type == 0
    elsif record.entry_type == 1
      if record.regular_band_id == nil
        record.errors[:base] << "バンドが選択されていません"
      end
    elsif record.entry_type == 2
      if record.temporal_band_id == nil
        record.errors[:base] << "バンドが選択されていません"
      end
    else
      if record.temporal_band_id == nil && record.regular_band_id == nil
        record.errors[:base] << "バンドが選択されていません"
      end
    end
    myEvents = Entry.where(user_id: record.user_id)
    if record.entry_type == 0
      if myEvents.any?
        if myEvents.where(event_id: record.event_id).any?
          record.errors[:base] << "すでにエントリーしています"
        end
      end
    else
      if record.regular_band_id
        if Entry.where(event_id: record.event_id).where(regular_band_id: record.regular_band_id).any?
          record.errors[:base] << "#{Band.find(record.regular_band_id).name}ですでにエントリーしています"
        end
      end
      if record.temporal_band_id
        if Entry.where(event_id: record.event_id).where(temporal_band_id: record.temporal_band_id).any?
          record.errors[:base] << "#{TemporalBand.find(record.temporal_band_id).name}ですでにエントリーしています"
        end
      end
    end

  end
end

class Entry < ApplicationRecord
  #entry_type ... 0,1,2,3
  #0.....個人エントリー
  #1.....正規バンドのみエントリー可
  #2.....企画バンドのみエントリー可
  #3.....正規・企画エントリー可
  validates_with EntryValidator
end
