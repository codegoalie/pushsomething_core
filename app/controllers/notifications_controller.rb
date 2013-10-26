class NotificationsController < ApplicationController
  authorize_resource

  def index
    @notifications = Notification.for_user(current_user)
  end

  def send_test
    params[:title] ||= t('test_notification.default_title')
    params[:body] ||= t('test_notification.default_body')

    Notification.to_user(current_user,
                         params[:title],
                         params[:body],
                         'test_notification')

    flash[:success] = t('test_notification.success')
    redirect_to :receivers
  end
end
