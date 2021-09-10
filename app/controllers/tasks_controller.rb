class TasksController < ApplicationController
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
      if Task.exists?(user_id: @task.user_id, name: @task.name)
        redirect_to request.referer,notice:"追加できませんでした"
      elsif @task.save
        redirect_to user_path(current_user)
      else
        redirect_to request.referer,notice:"追加できませんでした"
      end
  end

  def destroy
    task =Task.find(params[:id])
    if task.destroy
      redirect_to user_path(current_user)
    else
      redirect_to request.referer,notice:"削除できませんでした"
    end
  end

  private
    def task_params
       params.require(:task).permit(:name)
    end
end
