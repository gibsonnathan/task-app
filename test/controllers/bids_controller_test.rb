require "test_helper"

class BidsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bid = bids(:bid_one)
  end

  test "should get index" do
    get bids_url, headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    assert_response :success
  end

  test "should create bid" do
    assert_difference("Bid.count") do
      post bids_url, headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, params: { bid: { "task_id" => Task.first.id, "amount" => "100", "unit" => "USD" } }, as: :json
    end

    assert_response :created
  end

  test "should show bid" do
    get bid_url(@bid), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    assert_response :success
  end

  test "should update bid" do
    patch bid_url(@bid), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, params: { bid: {} }, as: :json
    assert_response :success
  end

  test "should soft delete bid" do
    assert_no_difference("Bid.count") do
      delete bid_url(@bid), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    end

    assert_response :no_content
  end

  private

  def bid_url(bid)
    "/api/v1/bids/#{bid.id}"
  end

  def bids_url
    return "/api/v1/bids/"
  end
end
