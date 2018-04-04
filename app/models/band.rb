class Band < ApplicationRecord
  has_many :mics, dependent: :destroy
  belongs_to :master, class_name: 'User', foreign_key: 'master_id'
  belongs_to :pa, class_name: 'User', foreign_key: 'pa_id'
  has_many :room_usages, dependent: :destroy
  has_many :band_members, dependent: :destroy
  has_many :users, through: :band_members
  has_many :mic_numbers, dependent: :destroy
  validates :name, presence: {message: 'バンド名を入力してください'}
  validates :master, presence: {message: 'バンマスは必須項目です'}
  validates :pa, presence: {message: 'PAは必須項目です'}, if: :regular_band?
  def regular_band?
    self.band_type == 0
  end
  def member_datas
    arr = Array.new()
    self.members.each do |member|
      if User.find_by(name: member)
        arr.push(User.find_by(name: member))
      else
        arr.push(User.new())
      end
    end
    return arr
  end
  def members
    self.users.pluck('name')
  end
  def self.member_repeat?(band1,band2)
    bool = false
    band1.members.each do |member|
      #TODO:配列同士をマージして2個以上あればtrue
      if band2.members.include?(member)
        bool = true
      end
    end
    return bool
  end

  def self.next_band_candidate(bands)
    next_band_candidate = []
    bands.each_with_index do |band1,i|
      candidates = []
      bands.each_with_index do |band2,i2|
        unless i == i2
          if Band.member_repeat?(band1,band2)
            candidates.push(band2)
          end
        end
      end
      puts candidates.class
      next_band_candidate.push(candidates)
    end
    return next_band_candidate
  end



end
