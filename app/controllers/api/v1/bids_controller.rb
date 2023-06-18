module Api
  module V1
    class BidsController < ApplicationController
      before_action :authenticate
      before_action :set_bid, only: %i[ show destroy ]
      before_action only: %i[ destroy ] do
        user_id = @bid.user_id
        user = User.find(user_id)
        authorize user
      end

      # GET /bids
      def index
        @bids = Bid.order(:updated_at).page params[:page]
        render json: @bids
      end

      # GET /bids/1
      def show
        render json: @bid
      end

      # POST /bids
      def create
        # create record of user at bid creation time
        user = get_user!

        task = Task.find(bid_params[:task_id])
        bid_placed = task.bid!(user, bid_params)

        if bid_placed
          render json: @bid, status: :created, location: api_v1_bid_url(@bid)
        else
          render json: @bid.errors, status: :unprocessable_entity
        end
      end

      # DELETE /bids/1
      def destroy
        @bid.update(deleted: true)
      end

      def api_v1_bid_url(id)
        return "/api/v1/bids/#{id}"
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_bid
        @bid = Bid.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def bid_params
        params.fetch(:bid, {}).permit(:task_id, :amount, :unit)
      end
    end
  end
end
