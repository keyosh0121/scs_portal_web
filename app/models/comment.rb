class CommentValidater < ActiveModel::Validator
  def validate(record)
    if record.comment.length < 10
      record.errors[:base] << "10文字以上入力してください"
    end
  end
end

class Comment < ApplicationRecord
  belongs_to :user
  validates_with CommentValidater
  validates :event_id,
    presence: {message: 'イベントが選択されていません'}
  validates :content_id,
    presence: {message: 'コンテンツが選択されていません'}

end
