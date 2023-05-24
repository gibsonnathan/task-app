require "test_helper"
require_relative "../../lib/auth0_client.rb"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get index" do
    get users_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  test "should not get index when unauthenticated" do
    get users_url, as: :json
    assert_response :unauthorized
  end

  test "should show user" do
    get user_url(@user), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  test "should not show user when unauthenticated" do
    get user_url(@user), as: :json
    assert_response :unauthorized
  end

  private

  def user_url(user)
    "/api/v1/users/#{user.id}"
  end

  def users_url
    return "/api/v1/users/"
  end
end
