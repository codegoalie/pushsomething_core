class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # devise :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :receivers
  has_many :services

  attr_accessible :name, :email, :password, :remember_me

  validates :name, :email, presence: true

  def self.find_for_google_oauth2(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0..20])
    end

    user
  end

  def self.find_or_create_by_email(email)
    user = User.where(email: email).first

    unless user
      user = User.create(name: email,
                         email: email,
                         password: Devise.friendly_token[0..20])
    end

    user
  end

  def to_s
    name
  end
end
