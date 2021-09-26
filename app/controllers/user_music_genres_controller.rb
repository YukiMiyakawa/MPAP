class UserMusicGenresController < ApplicationController
  before_action :authenticate_user!
  def create
    @user_music_genre = UserMusicGenre.new(user_music_genre_params)
    @user_music_genre.user_id = current_user.id
    if UserMusicGenre.exists?(user_id: @user_music_genre.user_id, music_genre_id: @user_music_genre.music_genre_id)
      redirect_to request.referer, flash: { music_genre_error: "既に追加されているジャンルです" }
    elsif @user_music_genre.save
      redirect_to user_path(current_user), notice: "ジャンル追加に成功しました"
    else
      redirect_to request.referer, flash: { music_genre_error: "ジャンル追加に失敗しました" }
    end
  end

  def destroy
    user_music_genre = UserMusicGenre.find(params[:id])
    if user_music_genre.destroy
      redirect_to user_path(current_user)
    else
      redirect_to request.referer, flash: { music_genre_error: "ジャンル削除に失敗しました" }
    end
  end

  private

  def user_music_genre_params
    params.require(:user_music_genre).permit(:music_genre_id)
  end
end
