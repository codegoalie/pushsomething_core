class Notification < ActiveRecord::Base

  has_and_belongs_to_many :receivers

  attr_accessible :title, :body, :collapse_key, :receivers

  after_create :send_notification

  def self.for_user(user)
    includes(:receivers).
    joins(with_receivers).
    where('notifications_receivers.receiver_id' => user.receivers)
  end

  def self.to_user(user, title, body, collapse_key)
    self.create!(receivers: user.receivers,
                 title: title,
                 body: body,
                 collapse_key: collapse_key)
  end

  private

    def send_notification
      registration_ids = receivers.pluck(:gcm_id)

      payload = { data: { title: title, body: body },
                  collapse_key: collapse_key }

      gcm = GCM.new(ENV['GCM_KEY'])
      gcm.send_notification(registration_ids, payload)
    end

    def self.with_receivers
      <<-SQL.strip_heredoc
        JOIN notifications_receivers
        ON notifications.id =
           notifications_receivers.notification_id
      SQL
    end
end
