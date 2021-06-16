class User < ApplicationRecord
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

  before_save{email.downcase!}

  has_secure_password
end
