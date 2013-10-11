class ReceiverMailer < ActionMailer::Base
  default from: 'chris@chrismar035.com'

  def first_timer(user)
    @user = user
    mail(to: @user.email, subject: I18n.t('welcome'))
  end
end

