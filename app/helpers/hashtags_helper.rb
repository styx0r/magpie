module HashtagsHelper
  def tagcloudsize(tag)
    # Return an appropriate font size for the tag cloud, normalized by most popular
    max_usage = Hashtag.maximum(:taggings_count)
    return (5 * (tag.taggings_count / max_usage.to_f)).floor
  end
end
