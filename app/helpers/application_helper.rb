module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def description(page_description)
    content_for(:description) { page_description }
  end

  def truncated_text(markdown_text)
    html = markdown_to_html(markdown_text)

    require 'sanitize'
    html = Sanitize.fragment(html).strip

    truncate(html, length: 250, separator: ' ')
  end

  def display_emoticons(text)
    emoticons = Emoticon.all
    emoticons.each do |emoticon|
  	  text.gsub!(emoticon.code, image_tag(emoticon.emoticon.url))
    end
    text
  end

  def markdown_to_html(markdown_text)
    # Converts remaining Markdown syntax to html tags using Kramdown.
    require 'kramdown'
    html = Kramdown::Document.new(markdown_text, auto_ids: false).to_html

    # Setup whitelist of html elements, attributes, and protocols.
    allowed_elements = ['a', 'p', 'ul', 'ol', 'li', 'strong', 'em', 'cite',
      'blockquote', 'code', 'pre', 'dl', 'dt', 'dd', 'br']
    allowed_attributes = {
      'a' => ['href'],
      'img' => ['src', 'alt']
    }
    allowed_protocols = {
      'a' => {
        'href' => ['http', 'https', 'mailto', :relative]
      }
    }

    # Clean text of any unwanted html tags.
    require 'sanitize'
    html = Sanitize.clean(
      html,
      elements: allowed_elements,
      attributes: allowed_attributes,
      protocols: allowed_protocols
    )

    # Remove any footnote or footnote reference links.
    require 'nokogiri'
    html = Nokogiri::HTML.parse(html)
    html.css('a').each do |a|
      if (a.get_attribute('href') =~ /^#fn:/) or
        (a.get_attribute('href') =~ /^#fnref:/)
        # `Nokogiri::XML::Node#unlink` removes the node from the document
        a.unlink
      end
    end

    # Converts nokogiri variable to html.
    html = html.to_html

    # Converts non-html links to html links.
    require 'rails_autolink'
    html = auto_link(html, sanitize: false)

    html = display_emoticons(html)

    return html
  end
end
