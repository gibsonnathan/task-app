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

  test "getting bids" do
    get bids_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    res = JSON.parse(response.body)
    assert_equal 2, res.length
  end

  test "getting bid" do
    get bid_url(@bid), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    res = JSON.parse(response.body)
    assert_not_nil res["task_id"]
    assert_not_nil res["user_id"]
    assert_not_nil res["amount"]
    assert_not_nil res["unit"]
    assert_not_nil res["deleted"]
  end

  test "bidding adds to watch list" do
    WatchedTask.delete_all
    user = User.where(email: "gibson_nathaniel1@columbusstate.edu")[0]
    assert_empty WatchedTask.where(user_id: user.id)
    post bids_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, params: { bid: { "task_id" => Task.first.id, "amount" => "100", "unit" => "USD" } }, as: :json
    watched_tasks = WatchedTask.where(user_id: user.id)
    assert_not_empty watched_tasks
    watched_task = watched_tasks[0]
    assert_equal Task.first.id, watched_task.task_id
    assert_equal user.id, watched_task.user_id
  end

  private

  def bid_url(bid)
    "/api/v1/bids/#{bid.id}"
  end

  def bids_url
    return "/api/v1/bids/"
  end
end
