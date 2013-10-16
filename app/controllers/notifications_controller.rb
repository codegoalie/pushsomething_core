class NotificationsController < ApplicationController
  authorize_resource

  def index
    @notifications = Notification.for_user(current_user)
  end
end
