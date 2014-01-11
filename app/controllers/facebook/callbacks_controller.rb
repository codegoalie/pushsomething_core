class Facebook::CallbacksController < ActionController::Base
  # before_filter :verify_signature, only: [:receive]

  def index
    render text: challenge_string
  end

  def create
    Rails.logger.info "Received Facebook Update:\n#{params}"

    render status: :ok
  end

  private

  def challenge_string
    Koala::Facebook::RealtimeUpdates.meet_challenge(params,
                                                    ENV['FACEBOOK_VERIFY'])
  end

  # def verify_signature
  #   computed = OpenSSL::HMAC.hexdigest('sha1',
  #                                      "sha1=#{ENV['FACEBOOK_APP_SECRET']}",
  #                                      request.body)

  #   unless headers['X-Hub-Signature'] == computed
  #     head :unauthorized
  #   end
  # end
end
