class Service < ActiveRecord::Base
  belongs_to :user

  before_create :ensure_token_presence

  validates :name, :user, presence: true

  def to_s
    name
  end

  private

    def ensure_token_presence
      self.token = generate_token if token.blank?
    end

    def generate_token
      loop do
        token = Devise.friendly_token
        break token unless Service.where(token: token).exists?
      end
    end
end
