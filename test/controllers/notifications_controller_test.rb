require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification = notifications(:notification_one)
  end

  test "getting a user's notifications should return success" do
    get "#{notifications_url}?user_id=#{users(:user_one).id}", headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  test "user two should not be able to get user one's notifications" do
    get "#{notifications_url}?user_id=#{users(:user_one).id}", headers: { "Authorization" => USER_TWO_AUTH_HEADER }, as: :json
    assert_response :unauthorized
  end

  test "updating a user's notifications should return success" do
    put notification_url(@notification), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, params: { watched_task: { "read" => true } }, as: :json
    assert_response :success
  end

  test "user two should not be able to update user one's notifications" do
    put notification_url(@notification), headers: { "Authorization" => USER_TWO_AUTH_HEADER }, params: { watched_task: { "read" => true } }, as: :json
    assert_response :unauthorized
  end

  private

  def notifications_url
    "/api/v1/notifications"
  end

  def notification_url(notification)
    "/api/v1/notifications/#{notification.id}"
  end
end
