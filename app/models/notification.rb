class Notification < ApplicationRecord
  validates :content, presence: true
end
