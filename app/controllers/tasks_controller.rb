class TasksController < ApplicationController
   def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:notice] = 'Task was successfully created.'
      redirect_to @task
    else
      render :new, status: :unprocessable_entity
    end
  end

  private # متدهای private فقط در داخل همین کلاس قابل دسترسی هستند

  def task_params
    params.require(:task).permit(:title, :completed) # پارامترهای مجاز برای Task رو تعریف می کنه
  end
end
