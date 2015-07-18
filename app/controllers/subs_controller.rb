class SubsController < ApplicationController
  before_action :redirect_to_index_unless_logged_in
  before_action :prohibits_non_moderators, only:[:edit, :update]

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = current_user.subs.new(sub_params)
    if @sub.save
      flash[:messages] = ["#{@sub.title} successfully created!"]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.includes(:moderator).find(params[:id])
    @subs = Sub.all
  end

  def edit
    @sub = Sub.includes(:moderator).find(params[:id])
  end

  def update
    @sub = Sub.includes(:moderator).find(params[:id])

    if @sub.update(sub_params)
      flash[:messages] = ["Update succesful"]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def prohibits_non_moderators
    @sub = Sub.includes(:moderator).find(params[:id])
    redirect_to subs_url unless @sub.moderator == current_user
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :moderator_id, :description)
  end
end
