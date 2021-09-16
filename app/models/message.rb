class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # def self.save_notification_message!(current_user, room_id, message_id, visited_id)
  #   # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
  #   notification = current_user.active_notifications.new(
  #     room_id: id,
  #     message_id: message_id,
  #     visited_id: visited_id,
  #     action: 'message'
  #   )
  #   # 自分の投稿に対するコメントの場合は、通知済みとする
  #   if notification.visitor_id == notification.visited_id
  #     notification.checked = true
  #   end
  #   notification.save if notification.valid?
  # end
end
