class StoryDecorator < Draper::Decorator
  delegate_all

  def illustrated_content
    h.illustrated_markdown_to_html model.id, 'Story', model.content
  end
end
