class UserMusicGenresController < ApplicationController
  before_action :authenticate_user!
  def create
    @user_music_genre = UserMusicGenre.new(user_music_genre_params)
    @user_music_genre.user_id = current_user.id
      if UserMusicGenre.exists?(user_id: @user_music_genre.user_id, music_genre_id: @user_music_genre.music_genre_id)
        redirect_to request.referer,notice:"追加できませんでした"
      elsif @user_music_genre.save
        redirect_to user_path(current_user)
      else
        redirect_to request.referer,notice:"追加できませんでした"
      end
  end

  def destroy
    user_music_genre = UserMusicGenre.find(params[:id])
    if user_music_genre.destroy
      redirect_to user_path(current_user)
    else
      redirect_to request.referer,notice:"削除できませんでした"
    end
  end

  private
    def user_music_genre_params
       params.require(:user_music_genre).permit(:music_genre_id)
    end
end
