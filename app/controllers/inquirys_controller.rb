class InquirysController < ApplicationController
  before_action :authenticate_user!
  def index
    # 入力画面を表示
    @inquiry = Inquiry.new
    render :action => 'index'
  end

  def confirm
    # 入力値のチェック
    if params[:inquiry].present?
      @inquiry = Inquiry.new(params[:inquiry].permit(:name, :email, :message))
      if @inquiry.valid?
        # OK。確認画面を表示
        render :action => 'confirm'
      else
        # NG。入力画面を再表示
        render :action => 'index'
      end
    else
      @inquiry = Inquiry.new
      render action: :index
    end
  end

  def thanks
    if params[:inquiry].present?
      # メール送信
      @inquiry = Inquiry.new(params[:inquiry].permit(:name, :email, :message))
      InquiryMailer.received_email(@inquiry).deliver

      # 完了画面を表示
      render :action => 'thanks'
    else
      @inquiry = Inquiry.new
      render action: :index
    end
  end

end
