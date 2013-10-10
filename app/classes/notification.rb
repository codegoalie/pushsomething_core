class Notification
  def self.to_user(user, title, body, collapse_key)
    registration_ids = user.receivers.pluck(:gcm_id)


    notification = { data: { title: title,
                             body: body },
                     collapse_key: collapse_key }

    gcm = GCM.new(ENV['GCM_KEY'])
    gcm.send_notification(registration_ids, notification)
  end
end
