module Api
  module V1
    class WatchedTasksController < ApplicationController
      before_action :authenticate
      before_action :set_watched_task, only: %i[ destroy ]
      before_action only: %i[ destroy ] do
        authorize @watched_task.user
      end

      def create
        user = User.find(watched_task_params[:user_id])
        authorize user
        if performed?
          return
        end

        watched_task = WatchedTask.where(task_id: watched_task_params[:task_id]).where(user_id: watched_task_params[:user_id])

        if watched_task.any?
          render json: watched_task, status: :conflict
          return
        end

        watched_task = WatchedTask.new(watched_task_params.merge({ :user_id => user.id }))
        if watched_task.save
          render json: watched_task, status: :created
        else
          render json: watched_task.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @watched_task.destroy
      end

      private

      def set_watched_task
        @watched_task = WatchedTask.find(params[:id])
      end

      def watched_task_params
        params.fetch(:watched_task, {}).permit(:task_id, :user_id)
      end

      def api_v1_watched_task_url(watched_task)
        return "/api/v1/watched_tasks/#{watched_task.id}"
      end
    end
  end
end
