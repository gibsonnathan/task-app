class WatchedTasksController < ApplicationController
  before_action :set_watched_task, only: %i[ show edit update destroy ]

  # GET /watched_tasks
  def index
    @watched_tasks = WatchedTask.order(:updated_at).page params[:page]
  end

  # GET /watched_tasks/1
  def show
  end

  # GET /watched_tasks/new
  def new
    @watched_task = WatchedTask.new
  end

  # GET /watched_tasks/1/edit
  def edit
  end

  # POST /watched_tasks
  def create
    # watched_task = WatchedTask.where(task_id: watched_task_params[:task_id]).where(user_id: watched_task_params[:user_id])

    # if watched_task.any?
    #   render json: watched_task, status: :conflict
    #   return
    # end

    # watched_task = WatchedTask.new(watched_task_params.merge({ :user_id => user.id }))

    @watched_task = WatchedTask.new(watched_task_params)

    if @watched_task.save
      redirect_to @watched_task, notice: "Watched task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /watched_tasks/1
  def update
    if @watched_task.update(watched_task_params)
      redirect_to @watched_task, notice: "Watched task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /watched_tasks/1
  def destroy
    @watched_task.destroy
    redirect_to watched_tasks_url, notice: "Watched task was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watched_task
      @watched_task = WatchedTask.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def watched_task_params
      params.fetch(:watched_task, {})
    end
end
