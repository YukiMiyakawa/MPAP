class Admins::InstrumentsController < ApplicationController
  def index
    @instruments = Instrument.all
    @instrument = Instrument.new
    @music_genres = MusicGenre.all
    @music_genre = MusicGenre.new
  end

  def create
    instrument = Instrument.new(instrument_params)
    if instrument.save
      redirect_to admins_instruments_path
    else
      redirect_to request.referer,notice:"追加できませんでした"
    end
  end

  def edit
    @instrument = Instrument.find(params[:id])
  end

  def update
    @instrument = Instrument.find(params[:id])
    if @instrument.update(instrument_params)
      redirect_to admins_instruments_path
    else
      redirect_to request.referer,notice:"追加できませんでした"
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
