class BidsController < ApplicationController
  before_action :set_bid, only: %i[ show edit update destroy ]

  # GET /bids
  def index
    @bids = Bid.order(:updated_at).page params[:page]
  end

  # GET /bids/1
  def show
  end

  # GET /bids/new
  def new
    @bid = Bid.new
  end

  # GET /bids/1/edit
  def edit
  end

  # POST /bids
  def create

    # user = get_user!

    # task = Task.find(bid_params[:task_id])
    # bid_placed = task.bid!(user, bid_params)

    # if bid_placed
    #   render json: @bid, status: :created, location: api_v1_bid_url(@bid)
    # else
    #   render json: @bid.errors, status: :unprocessable_entity
    # end
    @bid = Bid.new(bid_params)

    if @bid.save
      redirect_to @bid, notice: "Bid was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bids/1
  def update
    if @bid.update(bid_params)
      redirect_to @bid, notice: "Bid was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bids/1
  def destroy
    @bid.update(deleted: true)
    redirect_to bids_url, notice: "Bid was successfully destroyed."
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
