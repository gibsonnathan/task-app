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
        @tasks = Task.all

        render json: @tasks
      end

      # GET /tasks/1
      def show
        render json: @task
      end

      # POST /tasks
      def create
        # create record of user at task creation time
        unless user_exists?
          create_user
        end

        logger.debug("task params #{task_params}")
        @task = Task.new(task_params)

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
        @task.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_task
        @task = Task.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def task_params
        params.fetch(:task, {}).permit(:description, :user_id)
      end
    end
  end
end
