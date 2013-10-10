class WelcomeToPushSomething
  def self.call(user)
    Notification.to_user(user,
                         I18n.t('welcome'),
                         I18n.t('first_notification'),
                         'welcome_notification')


    ReceiverMailer.first_timer(user).deliver
  end
end
