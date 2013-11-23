class Receiver < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :notifications

  attr_accessible :nickname, :uid, :user_id, :gcm_id

  def to_s
    nickname || uid
  end
end
