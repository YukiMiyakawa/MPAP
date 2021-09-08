class FavoritesController < ApplicationController
  def create
    @main_post = MainPost.find(params[:main_post_id])
    favorite = current_user.favorites.new(main_post_id: @main_post.id)
    favorite.save
    # redirect_to main_post_path(main_post)
  end

  def destroy
    @main_post = MainPost.find(params[:main_post_id])
    favorite = current_user.favorites.find_by(main_post_id: @main_post.id)
    favorite.destroy
    # redirect_to main_post_path(main_post)
  end
end
