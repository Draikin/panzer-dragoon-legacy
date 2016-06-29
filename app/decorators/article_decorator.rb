class ArticleDecorator < Draper::Decorator
  delegate_all

  def illustrated_body
    h.illustrated_markdown_to_html model.id, "Article", model.content
  end
end
