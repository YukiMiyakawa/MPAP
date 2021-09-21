class FavoritesController < ApplicationController
  before_action :authenticate_user!
  def create
    @main_post = MainPost.find(params[:main_post_id])
    favorite = current_user.favorites.new(main_post_id: @main_post.id)
    favorite.save
    # いいね通知
    main_post = MainPost.find(params[:main_post_id])
    main_post.create_notification_like!(current_user)

    # redirect_to main_post_path(@main_post)
  end

  def destroy
    @main_post = MainPost.find(params[:main_post_id])
    favorite = current_user.favorites.find_by(main_post_id: @main_post.id)
    favorite.destroy

    # redirect_to main_post_path(@main_post)
  end
end
