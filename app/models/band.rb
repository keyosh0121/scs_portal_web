class Band < ApplicationRecord
  validates :name, presence: { message: 'バンド名を入力してください' }
  validates :master, presence: { message: 'バンマスは必須項目です' }
  validates :description, presence: { message: '説明を記載してください' }
  validates :pa, presence: { message: 'PAは必須項目です' }
  has_many :band_members
  has_many :users, through: :band_members
  accepts_nested_attributes_for :band_members
end
