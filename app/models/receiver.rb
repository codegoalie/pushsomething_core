class Receiver < ActiveRecord::Base

  belongs_to :user

  attr_accessible :uid, :user_id, :gcm_id
end
