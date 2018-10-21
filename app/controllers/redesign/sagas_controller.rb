class Redesign::SagasController < ApplicationController
  include LoadableForSaga
  layout 'redesign'

  def show
    load_saga
    load_article_categories
    load_resource_categories
    load_download_categories
    load_music_categories
    load_picture_categories
    load_video_categories
  end
end
