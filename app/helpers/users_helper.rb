module UsersHelper
  def gravatar_for user, options = {size: Settings.user.image.size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def delete? user
    current_user.admin? && !current_user?(user)
  end

  def follow_user_load
    current_user.active_relationships.build
  end

  def unfollow_user_load
    current_user.active_relationships.find_by(followed_id: @user.id)
  end
end
