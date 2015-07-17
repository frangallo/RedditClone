class PostsController < ApplicationController
  def new
    @post = Post.new
    render :new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.sub_id = params[:sub_id]
    if @post.save
      flash[:messages] = ["Post successful"]
      redirect_to sub_url(@post.sub)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.includes(:sub).find(params[:id])

    if @post.update(post_params)
      flash[:messages] = ["Post edit successful"]
      redirect_to sub_url(@post.sub)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def show
    @post = Post.includes(:sub,:author).find(params[:id])
    render :show
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content)
  end
end
