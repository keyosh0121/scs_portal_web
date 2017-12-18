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

end
