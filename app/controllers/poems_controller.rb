class PoemsController < ApplicationController
  include LoadableForPoem

  def index
    if params[:contributor_profile_id]
      load_contributors_poems
    else
      @poems = policy_scope(Poem.order(:name).page(params[:page]))
    end
  end

  def show
    load_poem
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @poem.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
