class Api::V1::ReceiversController < ActionController::Base
  before_filter :verify_params
  before_filter :verify_jwt

  def create
    @user = User.find_or_create_by_email(@user_email)

    @receiver = FetchOrBuildReceiver.call(params['uid'],
                                          params['gcm_id'],
                                          @user)
    WelcomeToPushSomething.call(@user, @receiver)
  end

  private

    def verify_jwt
      jwt = JWT.decode(params['jwt'], ENV['GOOGLE_SECRET'], false)

      if jwt['iss'] != 'accounts.google.com' &&
         jwt['aud'] != ENV['GOOGLE_ID']
        render 'auth_error', status: :unauthorized
      end

      @user_email = jwt['email']
    end

    def verify_params
      unless params['jwt'] && params['uid'] && params['gcm_id']
        render status: :bad_request, json: {}
      end
    end
end
