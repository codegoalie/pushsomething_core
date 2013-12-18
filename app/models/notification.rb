class Notification < ActiveRecord::Base
  has_and_belongs_to_many :receivers
  has_one :acknowledger, class_name: 'Receiver'

  attr_accessible :title, :body, :collapse_key, :receivers
  attr_writer :user

  validates :title, :body, presence: true

  after_create :send_notification

  default_scope order('created_at DESC')

  def self.find_for_user(user, id)
    self.for_user(user).where(id: id).first
  end

  def self.for_user(user)
    includes(:receivers)
    .joins(with_receivers)
    .where('notifications_receivers.receiver_id' => user.receivers)
  end

  def user=(user)
    receivers << user.receivers
  end

  def acknowledge(receiver)
    return false if acknowledged_at

    registration_ids = recievers.pluck(:gcm_id) - [reciever.gcm_id]

    payload = {
                data: {
                        type: 'acknowledgement',
                        notification_id: id
                      }
              }

    gcm = GCM.new(ENV['GCM_KEY'])
    gcm.send_notification(registration_ids, payload)

    self.acknowledged_at = Time.now
    self.acknowledger = receiver
    self.save
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
