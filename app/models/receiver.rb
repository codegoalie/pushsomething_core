class Receiver < ActiveRecord::Base
  belongs_to :user
  has_many :notifications, through: :notification_receivers

  attr_accessible :nickname, :uid, :user_id, :gcm_id

  def to_s
    nickname || uid
  end
end
