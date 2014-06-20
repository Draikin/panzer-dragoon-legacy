class EmoticonsController < ApplicationController
  def index
    @emoticons = policy_scope(Emoticon.order(:name).page(params[:page]))
  end

  def new
    @emoticon = Emoticon.new
    authorize @emoticon
  end

  def create
    @emoticon = Emoticon.new(emoticon_params)
    authorize @emoticon
    if @emoticon.save
      redirect_to emoticons_path, notice: "Successfully created emoticon."
    else
      render :new
    end
  end

  def destroy    
    @emoticon = Emoticon.find_by params[:id]
    authorize @emoticon
    @emoticon.destroy
    redirect_to emoticons_path, notice: "Successfully destroyed emoticon."
  end

  private

  def emoticon_params
    params.require(:emoticon).permit(:name, :emoticon)
  end
end
