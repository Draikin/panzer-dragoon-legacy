class Admin::PoemsController < ApplicationController
  include LoadableForPoem
  layout 'admin'
  before_action :load_poem, except: [:index, :new, :create]

  def index
    clean_publish_false_param
    @q = Poem.order(:name).ransack(params[:q])
    @poems = policy_scope(@q.result.page(params[:page]))
  end

  def new
    @poem = Poem.new
    authorize @poem
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @poem = Poem.new poem_params
    authorize @poem
    if @poem.save
      flash[:notice] = 'Successfully created poem.'
      redirect_to_poem
    else
      render :new
    end
  end

  def update
    params[:poem][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @poem.update_attributes poem_params
      flash[:notice] = 'Successfully updated poem.'
      redirect_to_poem
    else
      render :edit
    end
  end

  def destroy
    @poem.destroy
    redirect_to admin_poems_path, notice: 'Successfully destroyed poem.'
  end

  private

  def poem_params
    params.require(:poem).permit(
      policy(@poem || :poem).permitted_attributes
    )
  end

  def redirect_to_poem
    if params[:continue_editing]
      redirect_to edit_admin_poem_path(@poem)
    else
      redirect_to @poem
    end
  end
  
  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:poem][:contributor_profile_ids]
    )
      params[:poem][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
