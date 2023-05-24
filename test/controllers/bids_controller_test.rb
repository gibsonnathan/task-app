require "test_helper"

class BidsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bid = bids(:bid_one)
  end

  test "should get index" do
    get bids_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  test "should not get index when not authenticated" do
    get bids_url, as: :json
    assert_response :unauthorized
  end

  test "should create bid" do
    assert_difference("Bid.count") do
      post bids_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, params: { bid: { "task_id" => Task.first.id, "amount" => "100", "unit" => "USD" } }, as: :json
    end

    assert_response :created
  end

  test "creating bid with new user should create user" do
    assert_difference("User.count", 1) do
      post bids_url, headers: { "Authorization" => USER_NOT_IN_DB }, params: { bid: { "task_id" => Task.first.id, "amount" => "100", "unit" => "USD" } }, as: :json
    end

    assert_response :created
  end

  test "should not create bid when not authenticated" do
    post bids_url, params: { bid: { "task_id" => Task.first.id, "amount" => "100", "unit" => "USD" } }, as: :json
    assert_response :unauthorized
  end

  test "should show bid" do
    get bid_url(@bid), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  test "should not show bid when unauthenticated" do
    get bid_url(@bid), as: :json
    assert_response :unauthorized
  end

  test "should soft delete bid" do
    assert_no_difference("Bid.count") do
      delete bid_url(@bid), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    end

    assert_response :no_content
  end

  test "should not soft delete user one's bid" do
    assert_no_difference("Bid.count") do
      delete bid_url(@bid), headers: { "Authorization" => USER_TWO_AUTH_HEADER }, as: :json
    end

    assert_response :unauthorized
  end

  private

  def bid_url(bid)
    "/api/v1/bids/#{bid.id}"
  end

  def bids_url
    return "/api/v1/bids/"
  end
end
