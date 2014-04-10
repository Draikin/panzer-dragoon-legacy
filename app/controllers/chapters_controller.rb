class ChaptersController < ApplicationController
  
  def show    
    @chapter = Chapter.find_by_url(params[:id])
    authorize @chapter
    previous_and_next_chapters
  end

  def new
    story = Story.find_by_url(params[:story])
    raise "Story not found." unless story.present?
    @chapter = Chapter.new(story_id: story.id)
    authorize @chapter
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    authorize @chapter
    if @chapter.save
      redirect_to @chapter, notice: "Successfully created chapter."
    else
      render :new
    end
  end

  def edit
    @chapter = Chapter.find_by_url(params[:id])
    authorize @chapter
  end
  
  def update
    @chapter = Chapter.find_by_url(params[:id])
    authorize @chapter
    if @chapter.update_attributes(params[:chapter])
      redirect_to @chapter, notice: "Successfully updated chapter."
    else
      render :edit
    end
  end

  def destroy
    @chapter = Chapter.find_by_url(params[:id])
    authorize @chapter
    story = @chapter.story
    @chapter.destroy
    redirect_to story_path(story), notice: "Successfully destroyed chapter."
  end
  
  private

  def previous_and_next_chapters
    all_chapters =  policy_scope(@chapter.story.chapters)
    prologues = policy_scope(@chapter.story.chapters.where(chapter_type: :prologue).order(:number))
    regular_chapters = policy_scope(@chapter.story.chapters.where(chapter_type: :regular_chapter).order(:number))
    epilogues = policy_scope(@chapter.story.chapters.where(chapter_type: :epilogue).order(:number))

    all_chapters.each do |chapter|
      if (chapter.number == @chapter.number - 1) && (chapter.chapter_type == @chapter.chapter_type)
        @previous_chapter = chapter
      end
  	  if (chapter.number == @chapter.number + 1) && (chapter.chapter_type == @chapter.chapter_type)
  	    @next_chapter = chapter
  	  end
  	end
  	if (@chapter == prologues.order(:number).last) && regular_chapters
  	  @next_chapter = regular_chapters.first
  	end
	  if (@chapter == regular_chapters.order(:number).first) && prologues
      @previous_chapter = prologues.last
    end
    if (@chapter == regular_chapters.order(:number).last) && epilogues
      @next_chapter = epilogues.first
    end
    if (@chapter == epilogues.order(:number).first) && regular_chapters
      @previous_chapter = regular_chapters.last
    end
  end
  
end
