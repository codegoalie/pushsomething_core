class Api::V1::AcknowledgementsController <  ActionController::Base
  before_filter :authenticate_receiver_from_token!

  def create
    notification = Notification.find_for_user(@current_receiver.user,
                                              params[:notification_id])

    if notification
      notification.acknowledge!(@current_receiver)
      render json: {}, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  private

    def authenticate_receiver_from_token!
      uid = params[:uid].presence
      receiver = uid && Receiver.where(uid: uid).first

      if receiver && Devise.secure_compare(receiver.auth_token,
                                           params[:auth_token])
        @current_receiver = receiver
      else
        render json: {}, status: :unauthorized
      end
    end
end
