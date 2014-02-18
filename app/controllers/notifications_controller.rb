class NotificationsController < ApplicationController
  authorize_resource

  before_filter :set_default_notification_params, only: [:create]

  def index
    @notifications = Notification.for_user(current_user)
  end

  def create
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

  private

    def notification_params
      params.require(:notification).permit(:title, :body, :collapse_key)
    end

    def set_default_notification_params
      params[:notification][:title] ||= t('test_notification.default_title')
      params[:notification][:body] ||= t('test_notification.default_body')
      params[:notification][:collapse_key] ||= 'test_notification'
    end
end
