class RoomUsage < ApplicationRecord
  belongs_to :user
  belongs_to :band, optional: true
  belongs_to :period
  belongs_to :room
  serialize :period
  validates :user_id, presence: {message: "ユーザーが正しく登録されませんでした"}
  validates :room_id, presence: {message: "部屋を選択してください"}
  validates :period_id, presence: {message: "時限を選択してください"}
  validates :date, presence: {message: "日付を選択してください"}
  validates :applicant, presence: {message: "利用者を入力してください"}
  def self.delete_old_records
    one_year_ago = Date.today - 14
    self.where("date < one_year_ago").delete_all
  end
end
