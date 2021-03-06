class SubPostsController < ApplicationController
  before_action :authenticate_user!
  def create
    @new_sub_post = SubPost.new(sub_post_params)
    @new_sub_post.main_post_id = params[:main_post_id]

    # if params[:sub_post][:image] != "{}"
    #   @new_sub_post.check_image(params[:sub_post][:image].original_filename)
    #   if @new_sub_post.errors.any?
    #     redirect_to request.referer, flash: { sub_error: "JPG, PNG, GIFのみアップロードできます。" }
    #     return
    #   end
    # end

    if @new_sub_post.save
      redirect_to main_post_path(@new_sub_post.main_post_id), notice: "投稿に成功しました"
    else

      @main_post = MainPost.find(params[:main_post_id])
      @user = @main_post.user
      @tweets = @user.tweets.order(created_at: :desc).page(params[:page]).per(10)
      @sub_post = SubPost.new
      @sub_posts = SubPost.where(main_post_id: @main_post.id)
      @comments = Comment.where(main_post_id: @main_post.id).order(created_at: :desc).page(params[:page]).per(5)
      @comment = Comment.new
      @post_tags = @main_post.tags

      if user_signed_in?
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
      render "main_posts/show"
    end
  end

  def edit
    @main_post = MainPost.find(params[:main_post_id])
    @sub_post = SubPost.find(params[:id])
  end

  def update
    @main_post = MainPost.find(params[:main_post_id])
    @sub_post = SubPost.find(params[:id])

    # if params[:sub_post][:image] != "{}"
    #   @sub_post.check_image(params[:sub_post][:image].original_filename)
    #   if @sub_post.errors.any?
    #     render "edit"
    #     return
    #   end
    # end

    if @sub_post.update(sub_post_params)
      redirect_to main_post_path(@sub_post.main_post_id), notice: "更新に成功しました"
    else
      render "edit"
    end
  end

  def destroy
    sub_post = SubPost.find(params[:id])
    @sub_post = SubPost.find(params[:id])
    @sub_post.destroy
    redirect_to main_post_path(sub_post.main_post_id)
  end

  def sub_post_params
    params.require(:sub_post).permit(:title, :content, :image, :id, :audio, :youtube_url)
  end
end
