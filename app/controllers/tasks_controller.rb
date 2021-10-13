class TasksController < ApplicationController
  before_action :authenticate_user!ta
  def create
    @new_task = Task.new(task_params)
    @new_task.user_id = current_user.id
    if Task.exists?(user_id: @new_task.user_id, name: @new_task.name)
      redirect_to request.referer, notice: "追加できませんでした"
    elsif @new_task.save
      redirect_to user_path(current_user)
    else
      redirect_to request.referer, flash: { task_error: @new_task.errors.full_messages }
    end
  end

  def destroy
    task = Task.find(params[:id])
    if task.destroy
      redirect_to user_path(current_user)
    else
      redirect_to request.referer, notice: "削除できませんでした"
    end
  end

  private

  def task_params
    params.require(:task).permit(:name)
  end
end
