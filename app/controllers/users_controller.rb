class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tweet = Tweet.new
    @tweets = Tweet.where(user_id: @user.id)
    @user_music_genre = UserMusicGenre.new
    @user_music_genres = UserMusicGenre.where(user_id: @user.id)
    @user_instrument = UserInstrument.new
    @user_instruments = UserInstrument.where(user_id: @user.id)
    @task = Task.new
    @tasks = Task.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def unsubscribe
    @user = User.find_by(name: params[:name])
  end

  def withdraw
    @user = User.find_by(name: params[:name])
    @user.update(user_status: false)
    reset_session
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :target_time, :image)
  end
end
