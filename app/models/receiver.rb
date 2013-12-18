class Receiver < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :notifications

  before_save :ensure_auth_token

  attr_accessible :nickname, :uid, :user_id, :gcm_id

  def to_s
    nickname || uid
  end

  private

    def ensure_auth_token
      self.auth_token = generate_auth_token if auth_token.blank?
    end

    def generate_auth_token
      loop do
        token = Devise.friendly_token
        break token unless Receiver.where(auth_token: token).first
      end
    end
end
