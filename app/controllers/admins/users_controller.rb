class Admins::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admins_users_path
    else
      redirect_to edit_admins_user_path(@user),notice:"変更を保存できませんでした"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :user_status)
    end
end
