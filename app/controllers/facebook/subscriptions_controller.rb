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

    flash[:notice] = t(:success, scopes: [:subscriptions, :facebook])

    redirect_to services_path
  end

  def destroy
    updates.unsubscribe('user')
  end

  private

  def updates
    @updates ||= \
      Koala::Facebook::RealtimeUpdates.new(app_id: ENV['FACEBOOK_APP_ID'],
                                           secret: ENV['FACEBOOK_APP_SECRET'])
  end
end
