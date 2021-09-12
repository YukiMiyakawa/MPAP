class SubPostsController < ApplicationController
  def create
    @sub_post = SubPost.new(sub_post_params)
    @sub_post.main_post_id = params[:main_post_id]
    if  @sub_post.save
      redirect_to main_post_path(@sub_post.main_post_id), notice: "You have created book successfully."
    else
      @sub_posts = SubPost.all
      redirect_to request.referrer
    end
  end

  def edit
  #   puts "debug=#{params.inspect}"
  #   # byebug
    @main_post = MainPost.find(params[:main_post_id])
    @sub_post = SubPost.find(params[:id])
  end

  def update
    @sub_post = SubPost.find(params[:id])
    if  @sub_post.update(sub_post_params)
      redirect_to main_post_path(@sub_post.main_post_id), notice: "You have updated book successfully."
    else
      redirect_to request.referrer
    end
  end

  def destroy
    sub_post = SubPost.find(params[:id])
    @sub_post = SubPost.find(params[:id])
    @sub_post.destroy
    redirect_to main_post_path(sub_post.main_post_id)
  end

  def sub_post_params
    params.require(:sub_post).permit(:title, :content, :image, :id, :audio)
  end
end
