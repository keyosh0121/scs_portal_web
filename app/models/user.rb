class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  FOUR_YEARS_AGO = Date.today.year - 4
  validates :name, {presence: true}
  validates :email, {presence: true, uniqueness: true, format: {with: VALID_EMAIL_REGEX}}
  validates :tel, {presence: true}
  validates :year, presence: true, numericality: {only_integer: true, greater_than: FOUR_YEARS_AGO}
    validates :univ, {presence: true}
  validates :password, {presence: true}

  def bands
    user_bands = Array.new()
    Band.all.each do |band|
      if band.members.include?(self.name)
        if band.registration
          user_bands.push(band)
        end
      end
    end
    return user_bands
  end
  def temporal_bands
    user_bands = Array.new()
    TemporalBand.all.each do |band|
      if band.members.include?(self.name)
          user_bands.push(band)
      end
    end
    return user_bands
  end

  def band_names
    user_bands = Array.new()
    Band.all.each do |band|
      if band.members.include?(self.name)
        if band.registration
          user_bands.push(band.name)
        end
      end
    end
    return user_bands
  end

  def mics
    user_mics = Array.new()

    Mic.all.order("date").each do |mic|
      if self.bands.include?(Band.find_by(name: mic.band))
        user_mics.push(mic)
      elsif self.name == mic.sender
        user_mics.push(mic)
      end
    end
    return user_mics
  end

  def entries
    user_entries = Array.new()
    Entry.all.each do |entry|
      if entry.regular_band_id
        if self.bands.include?(Band.find(entry.regular_band_id))
          user_entries.push(entry)
        end
      elsif entry.temporal_band_id
        if self.temporal_bands.include?(TemporalBand.find(entry.temporal_band_id))
          user_entries.push(entry)
        end
      elsif entry.user_id == self.id
        user_entries.push(entry)
      end
    end
    return user_entries
  end
end
