module Api
  module V1
    class BidsController < ApplicationController
      before_action :authenticate
      before_action :set_bid, only: %i[ show update destroy ]
      before_action only: %i[update destroy] do
        user_id = @bid.user_id
        user = User.find(user_id)
        authorize user
      end

      # GET /bids
      def index
        @bids = Bid.all
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
        @bid = Bid.new(bid_params.merge({ :user_id => user.id }))

        if @bid.save
          render json: @bid, status: :created, location: url_for([:api, :v1, @bid])
        else
          render json: @bid.errors, status: :unprocessable_entity
        end
      end

      # DELETE /bids/1
      def destroy
        @bid.update(deleted: true)
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
