class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.name == nil
      record.errors[:base] << "名前が入力されていません"
    end
    if record.name.include?(" ") | record.name.include?("　")
      record.errors[:base] << "姓名はスペースを使用せず入力してください"
    end
    if record.email == nil
      record.errors[:base] << "メールアドレスを入力してください"
    end
    if record.tel == nil
      record.errors[:base] << "電話番号を入力してください"
    end
    if record.year == nil
      record.errors[:base] << "入会年度を選択してください"
    end
    if record.password == nil
      record.errors[:base] << "パスワードが入力されていません"
    end
  end
end

class User < ApplicationRecord
  attr_accessor :remember_token
  validates_with UserValidator

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

    Mic.all.order("date DESC").each do |mic|
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
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    #remember_digestは、remember_tokenを暗号化したものか問う
  end

end
