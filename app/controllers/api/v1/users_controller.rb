module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate
      before_action :set_user, only: %i[ show update destroy ]
      before_action only: %i[ update ] do
        authorize @user
      end

      # GET /users
      def index
        @users = User.all

        render json: @users
      end

      # GET /users/1
      def show
        render json: @user
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.fetch(:user, {})
      end
    end
  end
end
