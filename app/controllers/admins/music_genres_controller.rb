class Admins::MusicGenresController < ApplicationController
  before_action :authenticate_admin!

  def create
    music_genre = MusicGenre.new(music_genre_params)
    if music_genre.save
      redirect_to admins_instruments_path
    else
      redirect_to request.referer, flash: { error: "ジャンル名が入力されていません。もしくは既に使用されています。" }
    end
  end

  def edit
    @music_genre = MusicGenre.find(params[:id])
  end

  def update
    @music_genre = MusicGenre.find(params[:id])
    if @music_genre.update(music_genre_params)
      redirect_to admins_instruments_path
    else
      render "edit"
    end
  end

  def destroy
    music_genre = MusicGenre.find(params[:id])
    if music_genre.destroy
      redirect_to admins_instruments_path
    else
      redirect_to request.referer
    end
  end

  private
    def music_genre_params
       params.require(:music_genre).permit(:name)
    end
end
