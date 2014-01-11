class Facebook::SubscriptionsController < ActionController::Base
  def index
    graph = Koala::Facebook::API.new(current_user.facebook_token)

    @notifications = graph.get_connections('me', 'notifications')

    render json: @notifications
  end

  def create
    updates.subscribe('user',
                      'notifications',
                      facebook_callback_url,
                      ENV['FACEBOOK_VERIFY'])
  end

  def destroy
    updates.unsubscribe('user')
  end

  private

  def updates
    @updates ||= \
      Koala::Facebook::RealtimeUpdates.new(ENV['FACEBOOK_APP_ID'],
                                           ENV['FACEBOOK_APP_SECRET'])
  end
end
