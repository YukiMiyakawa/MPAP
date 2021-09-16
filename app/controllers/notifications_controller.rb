class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications
    # @notifications.where(checked: false).each do |notification|
    #   notification.update_attributes(checked: true)
    # end
    # rails cでデータを確認 count last
  end
end
