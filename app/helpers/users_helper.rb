module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, size)
    if user.guest?
      gravatar_id = Digest::MD5::hexdigest("guest")
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    end
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", size: size)
  end

end
