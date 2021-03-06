class UserInstrumentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @user_instrument = UserInstrument.new(user_instrument_params)
    @user_instrument.user_id = current_user.id
    if UserInstrument.exists?(user_id: @user_instrument.user_id, instrument_id: @user_instrument.instrument_id)
      redirect_to request.referer, flash: { instrument_error: "既に追加されている楽器です" }
    elsif @user_instrument.save
      redirect_to user_path(current_user), notice: "楽器追加に成功しました"
    else
      redirect_to request.referer, flash: { instrument_error: "楽器追加に失敗しました" }
    end
  end

  def destroy
    user_music_genre = UserInstrument.find(params[:id])
    if user_music_genre.destroy
      redirect_to user_path(current_user)
    else
      redirect_to request.referer, flash: { instrument_error: "楽器削除に失敗しました" }
    end
  end

  private

  def user_instrument_params
    params.require(:user_instrument).permit(:instrument_id)
  end
end
