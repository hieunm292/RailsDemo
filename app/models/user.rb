class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{email.downcase!}

  VALID_EMAIL_REGEX = Settings.user.email.valid_email_regex

  validates :name,
            presence: true,
            length: {maximum: Settings.user.name.max_length}

  validates :email,
            presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true

  validates :password,
            presence: true,
            length: {minimum: Settings.user.password.min_length}

  has_secure_password

  def remember
    @remember_token = User.new_token
    update_column :remember_digest, User.digest(@remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create string, cost: cost
    end
  end
end
