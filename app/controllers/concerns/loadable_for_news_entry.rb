module LoadableForNewsEntry
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :news_entry).order(:name)
    ).resolve
  end

  def load_news_entry
    @news_entry = NewsEntry.find_by url: params[:id]
    authorize @news_entry
  end

  def load_contributors_news_entries
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @news_entries = policy_scope(
      NewsEntry.where(contributor_profile_id: @contributor_profile.id)
        .order('created_at desc').page(params[:page])
    )
  end

  def load_draft_news_entries
    @news_entries = policy_scope(
      NewsEntry.where(publish: false).order('created_at desc')
        .page(params[:page])
    )
  end
end
