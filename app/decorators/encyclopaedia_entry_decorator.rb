class EncyclopaediaEntryDecorator < Draper::Decorator
  delegate_all

  def illustrated_content
    h.illustrated_markdown_to_html model.id, 'EncyclopaediaEntry', model.content
  end
end
