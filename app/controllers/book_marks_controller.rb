class BookMarksController < ApplicationController
  def index
    @user = User.find(params[:id])
    @book_marks = BookMark.where(user_id: params[:id]).page(params[:page]).per(9)
  end

  def create
    @main_post = MainPost.find(params[:main_post_id])
    book_mark = current_user.book_marks.new(main_post_id: @main_post.id)
    book_mark.save
    # redirect_to main_post_path(main_post)
  end

  def destroy
    @main_post = MainPost.find(params[:main_post_id])
    book_mark = current_user.book_marks.find_by(main_post_id: @main_post.id)
    book_mark.destroy
    # redirect_to main_post_path(main_post)
  end
end
