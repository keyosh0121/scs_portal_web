class ConvertColumnsInComment < ActiveRecord::Migration[5.1]
  def change
    #Change all the 'atevent' attributes to 'event_id'
    comment_ids = Comment.all.map{|com| Event.find_by(name: com.atevent)}.map(&:id)
    Comment.all.each_with_index {|com,i| com.update!(event_id: comment_ids[i]) }

    #Change all the 'atcontent' attributes to 'content_id'
    content_ids = Comment.all.map{|com| EventContent.find_by(name: com.atcontent)}.map(&:id)
    Comment.all.each_with_index {|com,i| com.update!(content_id: content_ids[i]) }

    #Change all the 'sender' attributes to 'sender_id'
    sender_ids = Comment.all.map{|com| User.find_by(name: com.sender)}.map(&:id)
    Comment.all.each_with_index {|com,i| com.update!(sender_id: sender_ids[i]) }
    #Replace all ReplyToComment to Comment, with extended columns in former migration
    ReplyToComment.all.each {|rep| Comment.new(sender: User.find_by(id: rep.sender_id).name, comment: rep.text, reply_to: rep.comment_id).save }
  end
end
