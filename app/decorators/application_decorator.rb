class ApplicationDecorator < Draper::Decorator
  def illustrated_content
    add_table_of_contents_to_content
    convert_content_to_html
    sanitize_content
    illustrate_content
  end

  private

  # Automatically insert the table of contents before the first second level
  # Atx-style header.
  def add_table_of_contents_to_content
    updated_markdown = ''
    contents_added = false
    model.content.each_line do |line|
      if line.start_with? "## " and !contents_added
        line = "## Contents\n\n* replace this with toc\n{:toc}" + "\n\n" +
          line
        contents_added = true
      end
      updated_markdown += line
    end
    model.content = updated_markdown
  end

  # Converts Markdown syntax to html tags using Kramdown.
  def convert_content_to_html
    require 'kramdown'
    model.content = Kramdown::Document.new(model.content, auto_ids: true)
      .to_html
  end

  # Clean text of any unwanted html tags.
  def sanitize_content
    # Setup whitelist of html elements, attributes, and protocols.
    allowed_elements = ['h2', 'h3', 'a', 'img', 'p', 'ul', 'ol', 'li', 'strong',
      'em', 'cite', 'blockquote', 'code', 'pre', 'dl', 'dt', 'dd', 'br', 'hr',
      'sup', 'div']
    allowed_attributes = {
      'a' => ['href', 'rel', 'rev', 'class'],
      'img' => ['src', 'alt', 'width', 'height'],
      'sup' => ['id'],
      'div' => ['class'],
      'li' => ['id'],
      'h2' => ['id'],
      'h3' => ['id']
    }
    allowed_protocols = {
      'a' => {
        'href' => ['#fn', '#fnref', 'http', 'https', 'mailto', :relative]
      }
    }

    require 'sanitize'
    model.content = Sanitize.clean(
      model.content,
      elements: allowed_elements,
      attributes: allowed_attributes,
      protocols: allowed_protocols
    )
  end

  def illustrate_content
    require 'nokogiri'
    html = Nokogiri::HTML.parse(model.content)

    html = remove_contents_and_references(html)
    html = remove_empty_table_of_contents(html)
    html = replace_paragraphs_with_divs(html)
    html = add_illustration_attributes(html)
    html = set_illustration_alignments(html)
    html = add_illustration_captions(html)
    html = make_illustrations_links(html)

    # Converts nokogiri variable to html.
    model.content = html.to_html
  end

  # Remove the "Contents" and "References" list items and links from the table
  # of contents.
  def remove_contents_and_references(html)
    html.css('li').each do |li|
      li.css('a').each do |a|
        if a.get_attribute('href').in?(['#contents', '#references'])
          li.remove
        end
      end
    end
    html
  end

  # Remove the table of contents heading and list if the list is empty.
  def remove_empty_table_of_contents(html)
    html.css('ul').each do |ul|
      li_count = 0
      ul.css('li').each do |li|
        li_count = li_count + 1
      end
      if li_count == 0
        ul.remove
        html.css('h2').each do |h2|
          h2.remove if h2.get_attribute('id') == 'contents'
        end
      end
    end
    html
  end

  # Replace paragraphs wrapping the images with divs.
  def replace_paragraphs_with_divs(html)
    html.css('img').each do |img|
      img.parent.name = 'div'
    end
    html
  end

  # Sets correct src, width, and height attributes for the illustration.
  def add_illustration_attributes(html)
    html.css('img').each do |img|
      file_name = img.get_attribute('src')
      if illustration = model.illustrations.where(
        illustration_file_name: file_name
      ).first
        img.set_attribute('src', illustration.illustration.url(:embedded))
        image_file = Paperclip::Geometry.from_file(
          illustration.illustration.path(:embedded))
        img.set_attribute('width', image_file.width.to_i.to_s)
        img.set_attribute('height', image_file.height.to_i.to_s)
        img.set_attribute('data-popover-src', illustration.illustration.url(
          :popover))
        popover_image_file = Paperclip::Geometry.from_file(
          illustration.illustration.path(:popover))
        img.set_attribute('data-popover-width',
          popover_image_file.width.to_i.to_s)
        img.set_attribute('data-popover-height',
          popover_image_file.height.to_i.to_s)
      else
        img.set_attribute('src', '')
      end
    end
    html
  end

  def set_illustration_alignments(html)
    # Alternate between aligning the divs left, right, or in a side by side
    # container.
    div_class = 'left'
    html.css('div').each do |div|
      unless div.get_attribute('class') == 'footnotes'
        image_count = 0
        div.css('img').each do |img|
          image_count = image_count + 1
        end
        if image_count == 2
          div.set_attribute('class', 'sidebyside')
        else
          if div_class == 'left'
            div.set_attribute('class', div_class)
            div_class = 'right'
          else
            div.set_attribute('class', div_class)
            div_class = 'left'
          end
        end
      end
    end

    # Align side by side images left and right by placing them inside divs.
    html.css('div.sidebyside').each do |div|
      div.search("img").wrap('<div></div>')
      div_class = 'sidebysideleft'
      div.css('div').each do |innerdiv|
        if div_class == 'sidebysideleft'
          innerdiv.set_attribute('class', div_class)
          div_class = 'sidebysideright'
        else
          innerdiv.set_attribute('class', div_class)
        end
      end
    end
    html
  end

  # Add image captions based on alternate text.
  def add_illustration_captions(html)
    html.css('img').each do |img|
      caption = img.get_attribute('alt')
      img.add_next_sibling('<p>' + caption + '</p>')
    end
    html
  end

  # Wrap each illustration with a popover link.
  def make_illustrations_links(html)
    html.css('div').each do |div|
      div.search("img").wrap('<a href="#" class="popover"></a>')
    end
    html
  end
end
