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

  def deliver(fetched)
    fb_notif = FacebookNotification.new(fetched)

    return if Notification.where(source: :facebook,
                                 source_id: fb_notif.id).exists?

    notification = Notification.new(receivers: @user.receivers,
                                    title: fb_notif.title,
                                    body: fb_notif.body,
                                    source: :facebook,
                                    source_id: fb_notif.id)

    unless notification.save
      Rails.logger.warn("FacebookNotifier: Failed to save notification\n " <<
                        notification.errors.full_messages)
    end
  end

  private

  class FacebookNotification
    attr_reader :id, :title, :body

    def initialize(raw_notification)
      @id = raw_notification ['id']
      @title = raw_notification['title']
      @body = if raw_notification['object']
                raw_notification['object']['name']
              else
                @title
              end
    end
  end

  def graph
    @graph ||= Koala::Facebook::API.new(@user.facebook_token)
  end
end
