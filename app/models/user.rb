class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: { message: '名前が入力されていません' }
  validates :email, presence: { message: 'メールアドレスを入力してください' }
  validates :tel, presence: { message: '電話番号を入力してください' }
  validates :year, presence: { message: '入会年度を選択してください' }
  has_many :band_members
  has_many :bands, through: :band_members
  has_secure_password

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

  def self.digest(string)
    # 暗号化
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    # ランダムなトークンを生成する
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    # remember_tokenにランダムなトークンを保存
    update_attribute(:remember_digest,User.digest(remember_token))
    # remember_digestにremember_tokenをBCryptで暗号化したものを保存
  end

  def authenticated?(remember_token)
    if remember_digest
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    # remember_digestは、remember_tokenを暗号化したものか問う
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
