class V5::AlbumsController < ApplicationController
  layout 'v5'
  include LoadableForAlbum

  before_action :load_categories, except: [:index, :destroy]
  before_action :load_album, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_drafts
    elsif params[:filter] == 'draft'
      load_draft_albums
    else
      @albums = policy_scope(Album.order(:name).page(params[:page]))
    end
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @album = Album.new category: category
    else
      @album = Album.new
    end
    authorize @album
  end

  def create
    the_params = synchronised_params(album_params)
    @album = Album.new the_params
    authorize @album
    if @album.save
      flash[:notice] = 'Successfully created album.'
      redirect_to_album_or_category
    else
      render :new
    end
  end

  def update
    params[:album][:contributor_profile_ids] ||= []
    params[:album][:encyclopaedia_entry_ids] ||= []
    the_params = synchronised_params(album_params)
    if @album.update_attributes the_params
      flash[:notice] = 'Successfully updated album.'
      redirect_to_album_or_category
    else
      render :edit
    end
  end

  def destroy
    @album.destroy
    redirect_to v5_pictures_path, notice: 'Successfully destroyed album.'
  end

  private

  def album_params
    params.require(:album).permit(
      policy(@album || :album).permitted_attributes
    )
  end

  def synchronised_params(the_params)
    if the_params['pictures_attributes']
      the_params['pictures_attributes'].each do |key, value|
        the_params['pictures_attributes'][key]['category_id'] =
          the_params['category_id']
        if value['name'].blank?
          the_params['pictures_attributes'][key]['name'] =
            the_params['name']
        end
        if value['description'].blank?
          the_params['pictures_attributes'][key]['description'] =
            the_params['description']
        end
        if value['information'].blank?
          the_params['pictures_attributes'][key]['information'] =
            the_params['information']
        end
        if value['contributor_profile_ids'].blank?
          the_params['pictures_attributes'][key]['contributor_profile_ids'] =
            the_params['contributor_profile_ids']
        end
        if value['encyclopaedia_entry_ids'].blank?
          the_params['pictures_attributes'][key]['encyclopaedia_entry_ids'] =
            the_params['encyclopaedia_entry_ids']
        end
        the_params['pictures_attributes'][key]['publish'] =
          the_params['publish']
      end
    end
    the_params
  end

  def redirect_to_album_or_category
    if params[:continue_editing]
      redirect_to edit_v5_album_path(@album)
    else
      redirect_to [:v5, @album.category]
    end
  end
end
