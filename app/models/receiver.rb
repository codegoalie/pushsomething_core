class Receiver < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :notifications

  attr_accessible :uid, :user_id, :gcm_id
end
