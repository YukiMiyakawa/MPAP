class CommentsController < ApplicationController
  def create
    main_post = MainPost.find(params[:main_post_id])
    @comment = Comment.new(main_post_params)
    @comment.user_id = current_user.id
    @comment.main_post_id = main_post.id
    if  @comment.save
      redirect_to main_post_path(params[:main_post_id]), notice: "You have created book successfully."
    else
      @comments = Comment.all
      redirect_to main_post_path(params[:main_post_id])
    end
  end

  def edit
     @main_post = MainPost.find(params[:main_post_id])
     @comment = Comment.find(params[:id])
  end

  def update
     @comment = Comment.find(params[:id])
    if  @comment.update(main_post_params)
      redirect_to main_post_path(@comment), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to main_post_path(params[:main_post_id])
  end

  private

  def main_post_params
    params.require(:comment).permit(:content)
  end
end
