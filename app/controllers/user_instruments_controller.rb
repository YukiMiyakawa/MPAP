class UserInstrumentsController < ApplicationController
  def create
    @user_instrument = UserInstrument.new(user_instrument_params)
    @user_instrument.user_id = current_user.id
      if UserInstrument.exists?(user_id: @user_instrument.user_id, instrument_id: @user_instrument.instrument_id)
        redirect_to request.referer,notice:"追加できませんでした"
      elsif @user_instrument.save
        redirect_to user_path(current_user)
      else
        redirect_to request.referer,notice:"追加できませんでした"
      end
  end

  def destroy
    user_music_genre = UserInstrument.find(params[:id])
    if user_music_genre.destroy
      redirect_to user_path(current_user)
    else
      redirect_to request.referer,notice:"削除できませんでした"
    end
  end

  private
    def user_instrument_params
       params.require(:user_instrument).permit(:instrument_id)
    end
end
