class RoomUsage < ApplicationRecord
  belongs_to :user
  belongs_to :band
  belongs_to :period
  serialize :period
  validates :user_id, presence: {message: "ユーザーが正しく登録されませんでした"}
  validates :band_id, presence: {message: "バンド名が入力されていません"}
  validates :room, presence: {message: "部屋を選択してください"}
  validates :period_id, presence: {message: "時限を選択してください"}
  validates :date, presence: {message: "日付を選択してください"}
  def self.delete_old_records
    one_year_ago = Date.today - 365
    self.where("date < one_year_ago").delete_all
  end

end
