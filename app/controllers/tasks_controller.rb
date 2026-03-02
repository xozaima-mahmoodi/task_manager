class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks
  def index
    # Base collection
    @all_user_tasks = current_user.tasks
    
    # Calculate stats for the dashboard
    @total_count = @all_user_tasks.count
    @pending_count = @all_user_tasks.where(status: 'Pending').count
    @in_progress_count = @all_user_tasks.where(status: 'In Progress').count
    @done_count = @all_user_tasks.where(status: 'Done').count

    # Apply search and filters to the main list
    @tasks = @all_user_tasks
    
    if params[:query].present?
      @tasks = @tasks.where("title LIKE ?", "%#{params[:query]}%")
    end

    if params[:status].present? && ['Pending', 'In Progress', 'Done'].include?(params[:status])
      @tasks = @tasks.where(status: params[:status])
    end
    
    @tasks = @tasks.order(due_date: :asc)
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy!
    redirect_to tasks_url, notice: "Task was successfully destroyed.", status: :see_other
  end

  # PATCH /tasks/1/toggle_status
  def toggle_status
    @task = current_user.tasks.find(params[:id])
    
    next_status = case @task.status
                  when 'Pending' then 'In Progress'
                  when 'In Progress' then 'Done'
                  else 'Pending'
                  end

    @task.update(status: next_status)
    redirect_to tasks_path(status: params[:current_filter]), notice: "Status updated to #{next_status}"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "Access denied: You do not have permission to access this task."
  end

  def task_params
    params.expect(task: [ :title, :description, :status, :due_date ])
  end
end