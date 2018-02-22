
class User < ApplicationRecord
  has_many :room_usages
  has_many :mics
  attr_accessor :remember_token
	validates :email, presence: true,uniqueness: true
  validates :tel, presence: true
  validates :year, presence: true
  validates :name, presence: true
  validates :password_digest, presence: true
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

  def change_status_to_ob_if_graduated
    #2018年4月1日0:00に2014入会のステータスを全員分OBにする
    current_year = Date.today.year
    graduating_year = current_year - 4
    graduates = User.where(year: graduating_year)
    graduates.each do |graduate|
      graduate.status = "OB"
      graduate.save
    end
  end

  def self.digest(string)
    #暗号化
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    #ランダムなトークンを生成する
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    #remember_tokenにランダムなトークンを保存
    update_attribute(:remember_digest,User.digest(remember_token))
    #remember_digestにremember_tokenをBCryptで暗号化したものを保存
  end

  def authenticated?(remember_token)
    if remember_digest
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    #remember_digestは、remember_tokenを暗号化したものか問う
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
