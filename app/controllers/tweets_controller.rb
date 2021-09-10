class TweetsController < ApplicationController
  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    if  @tweet.save
      redirect_to request.referrer, notice: "You have created book successfully."
    else
      redirect_to request.referrer
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @tweet = Tweet.find(params[:id])
  end

  def update
    @tweet = Tweet.find(params[:id])
    if  @tweet.update(tweet_params)
      redirect_to user_path(@tweet.user_id), notice: "You have updated book successfully."
    else
      redirect_to request.referrer
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to request.referrer
  end

  def tweet_params
    params.require(:tweet).permit(:comment, :practice_time)
  end
end
