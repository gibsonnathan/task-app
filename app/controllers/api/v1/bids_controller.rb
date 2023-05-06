module Api
  module V1
    class BidsController < ApplicationController
      before_action :set_bid, only: %i[ show update destroy ]

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
        @bid = Bid.new(bid_params)

        if @bid.save
          render json: @bid, status: :created, location: @bid
        else
          render json: @bid.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /bids/1
      def update
        if @bid.update(bid_params)
          render json: @bid
        else
          render json: @bid.errors, status: :unprocessable_entity
        end
      end

      # DELETE /bids/1
      def destroy
        @bid.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_bid
        @bid = Bid.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def bid_params
        params.fetch(:bid, {})
      end
    end
  end
end
