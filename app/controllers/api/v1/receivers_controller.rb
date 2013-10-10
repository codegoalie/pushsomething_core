class Api::V1::ReceiversController < ActionController::Base

  before_filter :verify_jwt

  def create
  end

  private

    def verify_jwt
      jwt = JWT.decode(params['jwt'], ENV['GOOGLE_SECRET'], false)

      if jwt['iss'] != 'accounts.google.com' &&
         jwt['aud'] != ENV['GOOGLE_ID']
        render 'auth_error'
      end

      @user_email = jwt['email']
    end
end
