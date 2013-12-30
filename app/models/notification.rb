class Notification < ActiveRecord::Base
  has_and_belongs_to_many :receivers
  belongs_to :acknowledger, class_name: 'Receiver'

  attr_accessible :title, :body, :collapse_key, :receivers
  attr_writer :user

  validates :title, :body, presence: true

  after_create :send_notification

  default_scope order('created_at DESC')

  def self.find_for_user(user, id)
    notification = self.where(id: id).first
    return nil unless notification

    return nil if (user.receivers & notification.receivers).empty?

    notification
  end

  def user=(user)
    receivers << user.receivers
  end

  def acknowledge!(receiver)
    return false if acknowledged_at

    registration_ids = receivers.pluck(:gcm_id) - [receiver.gcm_id]

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
    self.save!
  end

  private

    def send_notification
      registration_ids = receivers.pluck(:gcm_id)

      payload = {
                  data: {
                          type: :notification,
                          server_id: self.id,
                          title: title,
                          body: body
                        }
                }

      payload[:collapse_key] = collapse_key if collapse_key
      gcm = GCM.new(ENV['GCM_KEY'])
      gcm.send_notification(registration_ids, payload)
    end
end
