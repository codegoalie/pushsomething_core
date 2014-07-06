class FacebookWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    FacebookNotifier.new(user).deliver_all if user
  end
end
