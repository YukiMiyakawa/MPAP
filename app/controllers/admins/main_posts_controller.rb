class Admins::MainPostsController < ApplicationController
  def index
    @main_posts = MainPost.all
  end

  def show
    @main_post = MainPost.find(params[:id])
    @sub_posts = SubPost.where(main_post_id: @main_post.id)
    @comments = Comment.where(main_post_id: @main_post.id)
  end

  def destroy
     @main_post = MainPost.find(params[:id])
     @main_post.destroy
    redirect_to admins_main_posts_path
  end

  def update
    @main_post = MainPost.find(params[:id])
    if @main_post.update(main_post_params)
      redirect_to admins_main_post_path(@main_post)
    else
      redirect_to admins_main_posts_path,notice:"変更を保存できませんでした"
    end
  end

  private
    def main_post_params
      params.require(:main_post).permit(:public_status)
    end
end
