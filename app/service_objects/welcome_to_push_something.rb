class WelcomeToPushSomething
  def self.call(user, reciever)
    Notification.create!(receivers: [receiver],
                         title: I18n.t('welcome'),
                         body: I18n.t('first_notification'),
                         collapse_key: 'welcome_notification')

    ReceiverMailer.first_timer(user).deliver
  end
end
