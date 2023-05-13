require "test_helper"
require_relative "../../lib/auth0_client.rb"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test "should get index" do
    get users_url, headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    assert_response :success
  end

  test "should show user" do
    get user_url(@user), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, params: { user: {} }, as: :json
    assert_response :success
  end

  private

  def user_url(user)
    "/api/v1/users/#{user.id}"
  end

  def users_url
    return "/api/v1/users/"
  end
end
