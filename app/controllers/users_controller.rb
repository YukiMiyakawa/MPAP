class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  def index
    @users = User.all.where.not(user_status: false).page(params[:page]).per(6)
    @users_all = User.all
  end

  def show
    @user = User.find(params[:id])

    @tweet = Tweet.new
    @tweets = Tweet.where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(10)
    @user_music_genre = UserMusicGenre.new
    @user_music_genres = UserMusicGenre.where(user_id: @user.id).page(params[:page]).per(6)
    @user_instrument = UserInstrument.new
    @user_instruments = UserInstrument.where(user_id: @user.id).page(params[:page]).per(6)
    @task = Task.new
    @tasks = Task.where(user_id: @user.id)

    # 合計練習時間
    today = Date.today
    now = Time.current
    @today_min = @tweets.where(created_at: now.all_day).sum(:practice_time)
    @week_min = @tweets.where(created_at: today.all_week).sum(:practice_time)
    @month_min = @tweets.where(created_at: today.all_month).sum(:practice_time)
    @sum_min = @tweets.sum(:practice_time)

    # グラフ算出
    # 週間練習時間折れ線グラフ
    @practice_sum_chart = @user.microposts_period("week")
    # 週間練習達成率円グラフ
    unless @user.target_time.nil?
      week_target_time = @user.target_time * 7
      @target_time_rate = @week_min.to_i * 100 / week_target_time.to_i
    end
    if @target_time_rate.nil?
      @achievement_rate = {}
    elsif @target_time_rate > 100
      @achievement_rate = { "達成率" => @target_time_rate }
    elsif @target_time_rate < 100
      @un_target_time_rate = 100 - @target_time_rate
      @achievement_rate = { "達成率" => @target_time_rate, "未達成率" => @un_target_time_rate }
    else
      @achievement_rate = {}
    end

    if user_signed_in?
      @current_entry = Entry.where(user_id: current_user.id)
      # Entryモデルからメッセージ相手のレコードを抽出
      @another_entry = Entry.where(user_id: @user.id)
      unless @user.id == current_user.id
        @current_entry.each do |current|
          @another_entry.each do |another|
            # ルームが存在する場合
            if current.room_id == another.room_id
              @is_room = true
              @room_id = current.room_id
            end
          end
        end
        # ルームが存在しない場合は新規作成
        unless @is_room
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    # if params[:user][:image] != "{}"
    #   @user.check_image(params[:user][:image].original_filename)
    #   if @user.errors.any?
    #     render 'edit'
    #     return
    #   end
    # end

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィール更新に成功しました"
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
