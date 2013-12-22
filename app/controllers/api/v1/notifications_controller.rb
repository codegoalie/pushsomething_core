class  Api::V1::NotificationsController < ActionController::Base
  before_filter :authenticate_service_from_token!

  def create
    @notification = Notification.new(params[:notification])
    @notification.user = @current_service.user

    if @notification.save
      head :created
    else
      render 'create_error'
    end
  end

  private

    def authenticate_service_from_token!
      token = params[:token].presence
      @current_service = token && Service.where(token: token).first

      render json: {}, status: :unauthorized unless @current_service
    end
end
