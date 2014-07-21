class FacebookScheduler
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  def perform
    User.select(:id).where('facebook_uid is not null').find_each do |user|
      FacebookWorker.perform_async(user.id)
    end
  end
end
