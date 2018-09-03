class CommentValidater < ActiveModel::Validator
  def validate(record)
    if record.comment
      if record.comment.length < 10
        record.errors[:base] << "10文字以上入力してください"
      end
    end
  end
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :event_content
  validates_with CommentValidater
  validates :event_id,
    presence: {message: 'イベントが選択されていません'}
  validates :event_content_id,
    presence: {message: 'コンテンツが選択されていません'}
  #validates :publish,
   # presence: {message: '公開可否が選択されていません'}

end
