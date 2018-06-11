class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :room_usages, dependent: :destroy
  has_many :mics, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :band_members, dependent: :destroy
  has_many :bands, through: :band_members, dependent: :destroy
  has_one :master, class_name: 'Band', foreign_key: 'master_id'
  has_one :pa, class_name: 'Band', foreign_key: 'pa_id'
  attr_accessor :remember_token, :activation_token, :reset_token
	validates :email, presence: true,uniqueness: true
  validates :tel, presence: true
  validates :year, presence: true
  validates :name, presence: true
  validates :password_digest, presence: true
  validates :section, presence: true
  validates :univ, presence: true
  has_secure_password validations: false

  # def temporal_bands
  #   user_bands = Array.new()
  #   TemporalBand.all.each do |band|
  #     if band.members.include?(self.name)
  #         user_bands.push(band)
  #     end
  #   end
  #   return user_bands
  # end

  def password_confirmation_failure
      errors.add(:password, "が確認用と一致しません")
  end

  def name_space_validation
    if self.name.include?(" ") || self.name.include?("　")
      errors.add(:name, "にスペースが含まれています")
      return false
    else
      return true
    end
  end

  def band_names
    user_bands_name = Array.new()
    self.bands.each do |band|
      user_bands_name.push(band.name)
    end
    return user_bands_name
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

  #パスワード再設定用
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

end
