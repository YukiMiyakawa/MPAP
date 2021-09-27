class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    main_post = MainPost.find(params[:main_post_id])
    @new_comment = Comment.new(main_post_params)
    @new_comment.user_id = current_user.id
    @new_comment.main_post_id = main_post.id
    @main_post = @new_comment.main_post
    if @new_comment.save
      # コメント通知
      @main_post.create_notification_comment!(current_user, @new_comment.id)

      redirect_to main_post_path(params[:main_post_id]), notice: "投稿が完了しました"
    else

      redirect_to main_post_path(params[:main_post_id]), flash: { comment_error: @new_comment.errors.full_messages }
    end
  end

  def edit
    @main_post = MainPost.find(params[:main_post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(main_post_params)
      redirect_to main_post_path(@comment), notice: "編集が完了しました."
    else
      @main_post = MainPost.find(params[:main_post_id])
      render "edit"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to main_post_path(params[:main_post_id]), notice: "コメントを削除しました"
  end

  private

  def main_post_params
    params.require(:comment).permit(:content)
  end
end
