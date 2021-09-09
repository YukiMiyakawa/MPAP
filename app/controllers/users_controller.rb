class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @tweet = Tweet.new
    @tweets = Tweet.where(user_id: current_user.id)
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

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
