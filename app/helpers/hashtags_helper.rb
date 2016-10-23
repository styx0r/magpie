module HashtagsHelper
  def tagcloudsize(tag)
    # Return an appropriate font size for the tag cloud
    count = 2*tag.projects.length + 3*tag.models.length + tag.users.length + tag.microposts.length

    return [count, 10].min
  end
end
