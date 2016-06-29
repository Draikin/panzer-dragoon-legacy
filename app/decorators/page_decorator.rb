class PageDecorator < Draper::Decorator
  delegate_all

  def illustrated_content
    h.illustrated_markdown_to_html model.id, 'Page', model.content
  end
end
