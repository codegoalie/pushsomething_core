class NotificationsController < ApplicationController
  authorize_resource

  def index
    @notifications = Notification.for_user(current_user)
  end

  def send_test
    params[:title] ||= t('test_notification.default_title')
    params[:body] ||= t('test_notification.default_body')

    @notification = Notification.new(params[:notification])
    @notification.user = current_user

    if @notification.save
      flash[:success] = t('notification.success')
      redirect_to :notifications
    else
      flash[:alert] = t('notification.failure')
      render :new
    end
  end
end
