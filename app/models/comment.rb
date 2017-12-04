class CommentValidater < ActiveModel::Validator
  def validate(record)
    if record.text.length < 10
      record.errors[:base] << "10文字以上入力してください"
    end
  end
end

class Comment < ApplicationRecord
  validates_with CommentValidater
end
