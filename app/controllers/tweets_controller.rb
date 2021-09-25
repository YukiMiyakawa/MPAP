class TweetsController < ApplicationController
  def create
    @new_tweet = Tweet.new(tweet_params)
    @new_tweet.user_id = current_user.id
    if @new_tweet.save
      redirect_to request.referrer, notice: "You have created book successfully."
    else
      redirect_to request.referrer, flash: { tweet_error: @new_tweet.errors.full_messages }
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @tweet = Tweet.find(params[:id])
  end

  def update
    @edit_tweet = Tweet.find(params[:id])
    if @edit_tweet.update(tweet_params)
      redirect_to user_path(@edit_tweet.user_id), notice: "You have updated book successfully."
    else
      @tweet = Tweet.find(params[:id])
      @user = User.find(params[:user_id])
      render "edit"
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to request.referrer
  end

  def tweet_params
    params.require(:tweet).permit(:comment, :practice_time, :start_time)
  end
end
