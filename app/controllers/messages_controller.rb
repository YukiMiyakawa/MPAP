class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    # チャット通知
    # @visited_id = Message.select(:user_id).where(room_id: message.room_id).where.not(user_id: current_user.id).distinct
    @visited_id = params[:message][:visited_id]
    # byebug
    @room_id = message.room

    if message.save
      # チャット通知
      notification = current_user.active_notifications.new(
        room_id: @room_id.id,
        message_id: message.id,
        visited_id: @visited_id,
        action: 'message'
      )
      # 自分の投稿に対するコメントの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      # byebug
      notification.save if notification.valid?

      redirect_to room_path(message.room)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :body)
  end
end
