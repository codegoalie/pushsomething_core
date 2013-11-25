class Notification < ActiveRecord::Base
  has_many :receivers, through: :notifications_recievers

  attr_accessible :title, :body, :collapse_key, :receivers
  attr_writer :user

  validates :title, :body, presence: true

  after_create :send_notification

  default_scope order('created_at DESC')

  def self.for_user(user)
    includes(:receivers)
    .joins(with_receivers)
    .where('notifications_receivers.receiver_id' => user.receivers)
  end

  def user=(user)
    receivers << user.receivers
  end

  private

    def send_notification
      registration_ids = receivers.pluck(:gcm_id)

      payload = {
                  data: {
                          title: title,
                          body: body
                        }
                }

      payload[:collapse_key] = collapse_key if collapse_key
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
