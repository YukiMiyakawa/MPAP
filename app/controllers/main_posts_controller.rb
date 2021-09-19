class MainPostsController < ApplicationController
  def index
    @main_posts = MainPost.all.order(created_at: :DESC).page(params[:page]).per(8)
    @main_post_all = MainPost.all
    @tag_list= Tag.all.limit(6).sort {|a,b| b.post_tags.size <=> a.post_tags.size}
    @tweets = Tweet.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @main_post = MainPost.find(params[:id])
    @user = @main_post.user
    @tweets = @user.tweets.order(created_at: :desc).page(params[:page]).per(10)
    @sub_post = SubPost.new
    @sub_posts = SubPost.where(main_post_id: @main_post.id)
    @comments = Comment.where(main_post_id: @main_post.id)
    @comment = Comment.new
    @post_tags = @main_post.tags

    @current_entry = Entry.where(user_id: current_user.id)
    # Entryモデルからメッセージ相手のレコードを抽出
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          # ルームが存在する場合
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      # ルームが存在しない場合は新規作成
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
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
      @main_post = MainPost.new
      render 'new'
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