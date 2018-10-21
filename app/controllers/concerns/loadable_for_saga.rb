module LoadableForSaga
  extend ActiveSupport::Concern

  private

  def load_encyclopaedia_entries
    @encyclopaedia_entries = policy_scope(EncyclopaediaEntry.order(:name))
  end

  def load_saga
    @saga = Saga.find_by url: params[:id]
    authorize @saga
  end

  def load_article_categories
    @article_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(saga: @saga, category_type: :article).order(:name)
    ).resolve
  end

  def load_download_categories
    @download_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(saga: @saga, category_type: :download).order(:name)
    ).resolve
  end

  def load_music_track_categories
    @music_track_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(saga: @saga, category_type: :music_track).order(:name)
    ).resolve
  end

  def load_picture_categories
    @picture_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(saga: @saga, category_type: :picture).order(:name)
    ).resolve
  end

  def load_resource_categories
    @resource_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(saga: @saga, category_type: :resource).order(:name)
    ).resolve
  end

  def load_video_categories
    @video_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(saga: @saga, category_type: :video).order(:name)
    ).resolve
  end
end
