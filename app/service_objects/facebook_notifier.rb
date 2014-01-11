class FacebookNotifier
  def initialize(user)
    @user = user
  end

  def fetch_all
    graph.get_connections('me', 'notifications')
  end

  def deliver_all
    fetch_all.each do |fetched|
      deliver fetched
    end
  end

  def deliver(fb)
    return if Notification.where(source: :facebook,
                                 source_id: fetched['id']).exists?

    notification = Notification.new(receivers: @user.receivers,
                                    title: fetched['title'],
                                    body: fetched['title'],
                                    source: :facebook,
                                    source_id: fetched['id'])

    notification.body = fetched['object']['name'] if fetched['object']

    unless notification.save
      Rails.logger.warn("FacebookNotifier: Failed to save notification\n " <<
                        notification.errors.full_messages)
    end
  end

  private

  def graph
    @graph ||= Koala::Facebook::API.new(@user.facebook_token)
  end
end
