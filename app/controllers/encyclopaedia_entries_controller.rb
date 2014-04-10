class EncyclopaediaEntriesController < ApplicationController
  
  before_filter :categories

  def index
    @encyclopaedia_entries = policy_scope(EncyclopaediaEntry.order(:name).page(params[:page]))
  end

  def show
    @encyclopaedia_entry = EncyclopaediaEntry.find_by_url(params[:id])
    authorize @encyclopaedia_entry

    @articles = ArticlePolicy::Scope.new(@encyclopaedia_entry.articles.order(:name)).resolve
    @downloads = DownloadPolicy::Scope.new(@encyclopaedia_entry.downloads.order(:name)).resolve
    @links = LinkPolicy::Scope.new(@encyclopaedia_entry.links.order(:name)).resolve
    @music_tracks = MusicTrackPolicy::Scope.new(@encyclopaedia_entry.music_tracks.order(:name)).resolve
    @pictures = PicturePolicy::Scope.new(@encyclopaedia_entry.pictures.order(:name)).resolve
    @poems = PoemPolicy::Scope.new(@encyclopaedia_entry.poems.order(:name)).resolve
    @quizzes = QuizPolicy::Scope.new(@encyclopaedia_entry.quizzes.order(:name)).resolve
    @resources = ResourcePolicy::Scope.new(@encyclopaedia_entry.resources.order(:name)).resolve
    @stories = StoryPolicy::Scope.new(@encyclopaedia_entry.stories.order(:name)).resolve
    @videos = VideoPolicy::Scope.new(@encyclopaedia_entry.videos.order(:name)).resolve
  end

  def new
    @encyclopaedia_entry = EncyclopaediaEntry.new
    authorize @encyclopaedia_entry
  end

  def create 
    @encyclopaedia_entry = EncyclopaediaEntry.new(params[:encyclopaedia_entry])
    authorize @encyclopaedia_entry
    if @encyclopaedia_entry.save
      redirect_to @encyclopaedia_entry, notice: "Successfully created encyclopaedia entry."
    else
      render :new
    end
  end

  def edit
    @encyclopaedia_entry = EncyclopaediaEntry.find_by_url(params[:id])
    authorize @encyclopaedia_entry
  end

  def update
    @encyclopaedia_entry = EncyclopaediaEntry.find_by_url(params[:id])
    authorize @encyclopaedia_entry
    params[:encyclopaedia_entry][:article_ids] ||= []
    params[:encyclopaedia_entry][:download_ids] ||= []
    params[:encyclopaedia_entry][:link_ids] ||= []
    params[:encyclopaedia_entry][:music_track_ids] ||= []
    params[:encyclopaedia_entry][:picture_ids] ||= []
    params[:encyclopaedia_entry][:poem_ids] ||= []
    params[:encyclopaedia_entry][:quiz_ids] ||= []
    params[:encyclopaedia_entry][:resource_ids] ||= []
    params[:encyclopaedia_entry][:story_ids] ||= []
    params[:encyclopaedia_entry][:video_ids] ||= []
    if @encyclopaedia_entry.update_attributes(params[:encyclopaedia_entry])
      redirect_to @encyclopaedia_entry, notice: "Successfully updated encyclopaedia entry."
    else
      render :edit
    end
  end

  def destroy    
    @encyclopaedia_entry.destroy
    authorize @encyclopaedia_entry
    redirect_to encyclopaedia_entries_path, notice: "Successfully destroyed encyclopaedia entry."
  end
  
  private

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :encyclopaedia_entry).order(:name)).resolve
  end

end
