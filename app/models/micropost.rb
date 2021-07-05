class Micropost < ApplicationRecord
  belongs_to :user
  scope :newset, ->{order(created_at: :desc)}
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true,
             length: {maximum: Settings.user.validate_content}

  validates :image, content_type: {
    in: %w(image/jpeg image/gif image/png),
    message: I18n.t(".must_valid_image_format")
  },
    size: {
      less_than: Settings.user.image_max_size.megabytes,
      message: I18n.t(".image_size_less_than"), max_size:
                      Settings.user.image_max_size
    }

  def display_image
    image.variant resize_to_limit: [500, 500]
  end
end
