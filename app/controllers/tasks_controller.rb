class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks
  def index
    # Fetches only tasks belonging to the current logged-in user
    @tasks = current_user.tasks
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    # Builds a new task associated with the current user
    @task = current_user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    # Initializes a new task through the user relationship
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

  private

  # Enhanced security for fetching tasks
  def set_task
    # This prevents users from accessing other users' tasks by manually changing IDs in the URL
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "Access denied: You do not have permission to access this task."
  end

  # Only allow a list of trusted parameters through
  def task_params
    params.expect(task: [ :title, :description, :status ])
  end
end