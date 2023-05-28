module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate
      before_action :set_task, only: %i[ show update destroy ]
      before_action only: %i[update destroy] do
        user_id = @task.user_id
        user = User.find(user_id)
        authorize user
      end

      # GET /tasks
      def index
        @tasks = Task.order(updated_at: :desc)

        if filtering_by_location?
          @tasks = @tasks.select { |t| t.in_radius?(params[:lat].to_f, params[:long].to_f, params[:radius].to_f) }
        end

        render json: Kaminari.paginate_array(@tasks).page(params[:page])
      end

      # GET /tasks/1
      def show
        render json: @task
      end

      # POST /tasks
      def create
        # create record of user at task creation time
        user = get_user!

        @task = Task.new(task_params.merge({ :user_id => user.id }))

        if @task.save
          render json: @task, status: :created, location: url_for([:api, :v1, @task])
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /tasks/1
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # DELETE /tasks/1
      def destroy
        @task.update(deleted: true)
      end

      def api_v1_task_url(id)
        return "/api/v1/tasks/#{id}"
      end

      private

      def filtering_by_location?
        ![params[:lat], params[:long], params[:radius]].any? { |p| p.nil? }
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_task
        @task = Task.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def task_params
        params.fetch(:task, {}).permit(:description, :lat, :long, :title)
      end
    end
  end
end
