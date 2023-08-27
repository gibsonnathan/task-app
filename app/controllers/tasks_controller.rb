class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks
  def index
    @tasks = Task.order(updated_at: :desc)

    if filtering_by_location?
      @tasks = @tasks.select { |t| t.in_radius?(params[:lat].to_f, params[:long].to_f, params[:radius].to_f) }
    end

    @tasks = Kaminari.paginate_array(@tasks).page(params[:page])
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    # user = get_user!

    # @task = Task.new(task_params.merge({ :user_id => user.id }))
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.update(deleted: true)
    puts @task.deleted
    redirect_to tasks_url, notice: "Task was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.fetch(:task, {})
    end

    def filtering_by_location?
      ![params[:lat], params[:long], params[:radius]].any? { |p| p.nil? }
    end
end
