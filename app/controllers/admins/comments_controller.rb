class Admins::CommentsController < ApplicationController
  before_action :authenticate_admin!
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admins_main_post_path(params[:main_post_id])
  end
end
