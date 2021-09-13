class MainPostsController < ApplicationController
  def index
    @main_posts = MainPost.all
    @tag_list= Tag.all
  end

  def show
    @main_post = MainPost.find(params[:id])
    @sub_post = SubPost.new
    @sub_posts = SubPost.where(main_post_id: @main_post.id)
    @comments = Comment.where(main_post_id: @main_post.id)
    @comment = Comment.new
    @post_tags = @main_post.tags
  end

  def new
    @main_post = MainPost.new
  end

  def create
    @main_post = MainPost.new(main_post_params)
    @main_post.user_id = current_user.id
    tag_list=params[:main_post][:tag_name].split(',')
    # byebug
    if  @main_post.save
      @main_post.save_tag(tag_list)
      redirect_to main_post_path(@main_post), notice: "You have created book successfully."
    else
      @main_posts = MainPost.all
      render 'index'
    end
  end

  def edit
     @main_post = MainPost.find(params[:id])
     @tag_list = @main_post.tags.pluck(:name).join(',')
  end

  def update
    @main_post = MainPost.find(params[:id])
    tag_list = params[:main_post][:tag_name].split(',')
    if  @main_post.update(main_post_params)
      # このpost_idに紐づいていたタグを@oldに入れる
      @old_relations = PostTag.where(main_post_id: @main_post.id)
      # それらを取り出し、消す。消し終わる
      @old_relations.each do |relation|
        relation.delete
      end
      @main_post.save_tag(tag_list)
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

  def user_main_post
    @main_posts = MainPost.where(user_id: params[:id])
  end

  private

  def main_post_params
    params.require(:main_post).permit(:title, :content, :image, :audio, :youtube_url)
  end
end
