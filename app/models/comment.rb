class CommentValidater < ActiveModel::Validator
  def validate(record)
    if record.comment.length < 10
      record.errors[:base] << "10文字以上入力してください"
    end
  end
end

class Comment < ApplicationRecord
  validates_with CommentValidater
  validates :atevent,
    presence: {message: 'イベントが選択されていません'}
  validates :atcontent,
    presence: {message: 'コンテンツが選択されていません'}

end
