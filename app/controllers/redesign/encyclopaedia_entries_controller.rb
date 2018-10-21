class Redesign::EncyclopaediaEntriesController < ApplicationController
  include LoadableForEncyclopaediaEntry
  layout 'redesign'

  def index
    load_category_groups
    @encyclopaedia_entries = policy_scope(
      EncyclopaediaEntry.order(:name).page(params[:page])
    )
  end

  def show
    load_encyclopaedia_entry
  end
end
