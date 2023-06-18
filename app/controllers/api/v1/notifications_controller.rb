module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate
      before_action :set_notification, only: %i[ update ]

      # GET /notifications
      def index
        user_id = params[:user_id]
        user = User.find(user_id)
        authorize user
        if performed?
          return
        end

        @notifications = user.notifications.order(:updated_at).page params[:page]

        render json: @notifications
      end

      # PATCH/PUT /notifications/1
      def update
        user = @notification.user
        authorize user

        if performed?
          return
        end

        if @notification.update(notification_params)
          render json: @notification
        else
          render json: @notification.errors, status: :unprocessable_entity
        end
      end

      private

      def set_notification
        @notification = Notification.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def notification_params
        params.fetch(:notification, {}).permit(:read)
      end
    end
  end
end
