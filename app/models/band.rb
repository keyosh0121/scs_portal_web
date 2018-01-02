class Band < ApplicationRecord
  validates :name, presence: {message: 'バンド名を入力してください'}
  validates :master, presence: {message: 'バンマスは必須項目です'}
  validates :description, presence: {message: '説明を記載してください'}
  validates :pa, presence: {message: 'PAは必須項目です'}

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
    BandMember.where(band_id: self.id).pluck('name')
  end
  def self.member_repeat?(band1,band2)
    bool = false
    band1.members.each do |member|
      if band2.members.include?(member)
        bool = true
      end
    end
    return bool
  end

end
