class Band < ApplicationRecord
  validates :name, presence: true
  validates :master, presence: true
  validates :description, presence: true
  validates :pa, presence: true

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
