class Admins::InstrumentsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @instruments = Instrument.all
    @instrument = Instrument.new
    @music_genres = MusicGenre.all
    @music_genre = MusicGenre.new
  end

  def create
    @new_instrument = Instrument.new(instrument_params)
    if @new_instrument.save
      redirect_to admins_instruments_path
    else
      redirect_to request.referer, flash: { error: "ジャンル名が入力されていません。もしくは既に使用されています。" }
    end
  end

  def edit
    @instrument = Instrument.find(params[:id])
  end

  def update
    @instrument = Instrument.find(params[:id])
    # byebug
    if @instrument.update(instrument_params)
      redirect_to admins_instruments_path
    else
      render "edit"
    end
  end

  def destroy
    instrument = Instrument.find(params[:id])
    if instrument.destroy
      redirect_to admins_instruments_path
    else
      redirect_to request.referer,notice:"削除できませんでした"
    end
  end

  private
    def instrument_params
       params.require(:instrument).permit(:name)
    end
end
