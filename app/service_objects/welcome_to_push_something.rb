class WelcomeToPushSomething
  def self.call(user)
    notification = Notification.new(title: I18n.t('welcome'),
                                    body: I18n.t('first_notification'),
                                    collapse_key: 'welcome_notification')

    notification.user = user
    notification.save!

    ReceiverMailer.first_timer(user).deliver
  end
end
