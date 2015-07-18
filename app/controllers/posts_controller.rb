class PostsController < ApplicationController
  before_action :prohibits_non_authors, only: [:edit, :update]

  def new
    @post = Post.new
    @subs = Sub.all
    render :new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:messages] = ["Post successful"]
      redirect_to subs_url
    else
      fail
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.includes(:subs).find(params[:id])
    @post.sub_ids = params[:post][:sub_ids]
    if @post.update(post_params)
      flash[:messages] = ["Post edit successful"]
      redirect_to subs_url
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def show
    @post = Post.includes(:subs,:author).find(params[:id])
    render :show
  end

  def prohibits_non_authors
    @post = Post.includes(:author, :subs).find(params[:id])
    redirect_to sub_url(@post.sub) unless @post.author == current_user
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
