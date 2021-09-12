class MainPostsController < ApplicationController
  def index
    @main_posts = MainPost.all
  end

  def show
    @main_post = MainPost.find(params[:id])
    @sub_post = SubPost.new
    @sub_posts = SubPost.where(main_post_id: @main_post.id)
    @comments = Comment.where(main_post_id: @main_post.id)
    @comment = Comment.new
  end

  def new
    @main_post = MainPost.new
  end

  def create
    @main_post = MainPost.new(main_post_params)
    @main_post.user_id = current_user.id
    if  @main_post.save
      redirect_to main_post_path(@main_post), notice: "You have created book successfully."
    else
      @main_posts = MainPost.all
      render 'index'
    end
  end

  def edit
     @main_post = MainPost.find(params[:id])
  end

  def update
     @main_post = MainPost.find(params[:id])
    if  @main_post.update(main_post_params)
      redirect_to main_post_path(@main_post), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
     @main_post = MainPost.find(params[:id])
     @main_post.destroy
    redirect_to main_posts_path
  end

  private

  def main_post_params
    params.require(:main_post).permit(:title, :content, :image, :audio, :youtube_url)
  end
end
