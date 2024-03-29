class Notification < ActiveRecord::Base
  has_and_belongs_to_many :receivers
  belongs_to :acknowledger, class_name: 'Receiver'

  validates :title, :body, presence: true

  after_create :send_notification

  scope :for_user, ->(user) do
    joins(:receivers).where('receivers.id' => user.receivers)
                     .group('notifications.id')
  end
  default_scope -> { order('notifications.created_at DESC') }

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
      payload[:data][:source] = source if source.present?
      payload[:data][:source_id] = source_id if source_id.present?
      payload[:data][:remote_icon] = remote_icon if remote_icon.present?
      payload[:collapse_key] = collapse_key if collapse_key

      gcm = GCM.new(ENV['GCM_KEY'])
      gcm.send_notification(registration_ids, payload)
    end
end
