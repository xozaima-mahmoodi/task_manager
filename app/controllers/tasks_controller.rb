class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy toggle_status ]
  before_action :authenticate_user!

  def index
    sort_column = params[:sort] || 'created_at'
    sort_direction = params[:direction] || 'desc'
    allowed_columns = ['title', 'due_date', 'created_at', 'status']
    sort_column = 'created_at' unless allowed_columns.include?(sort_column)

    @per_page = params[:per_page].present? ? params[:per_page].to_i : 10
    
    @tasks = current_user.tasks.order("#{sort_column} #{sort_direction}")
    @tasks = @tasks.where(status: params[:status]) if params[:status].present?
    @tasks = @tasks.where("title LIKE ?", "%#{params[:query]}%") if params[:query].present?
    @tasks = @tasks.page(params[:page]).per(@per_page)

    @total_count = current_user.tasks.count
    @pending_count = current_user.tasks.where(status: 'Pending').count
    @in_progress_count = current_user.tasks.where(status: 'In Progress').count
    @done_count = current_user.tasks.where(status: 'Done').count
  end

  # New action for Quick Complete
  def toggle_status
    new_status = @task.status == 'Done' ? 'Pending' : 'Done'
    @task.update(status: new_status)
    redirect_to tasks_path(page: params[:page], per_page: params[:per_page], status: params[:filter_status])
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def edit
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task was successfully destroyed."
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end