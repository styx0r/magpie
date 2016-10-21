module ApplicationHelper
  def full_title(page_title)
    base_title = "Modeling Framework"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

def hashtag_link(tag)
  if Hashtag.exists?(tag: tag)
    link_to(raw("<font color='blue'>##{tag}</font>"), hashtag_path(tag))
  else
    "##{tag}"
  end
end

def markdown(text)
  # Renders markdown-formatted text

  # Handle empty (nil) text
  if text == nil
     return ''
  end

   options = {
     filter_html:     true,
     hard_wrap:       true,
     link_attributes: { rel: 'nofollow', target: "_blank" },
     space_after_headers: true,
     fenced_code_blocks: true
   }

   extensions = {
     autolink:           true,
     superscript:        true,
     disable_indented_code_blocks: true
   }

   renderer = Redcarpet::Render::HTML.new(options)
   markdown = Redcarpet::Markdown.new(renderer, extensions)

   markdown.render(text).html_safe
 end
end
