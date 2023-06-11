require "test_helper"

class WatchedTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @watched_task = watched_tasks(:watched_task_one)
  end

  test "should create watched task" do
    post watched_tasks_url, headers: { "Authorization" => USER_TWO_AUTH_HEADER }, params: { watched_task: { "task_id" => Task.first.id, "user_id" => User.second.id } }, as: :json
    assert_response :created
  end

  test "user one cannot create watched task for user two" do
    post watched_tasks_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, params: { watched_task: { "task_id" => Task.first.id, "user_id" => User.second.id } }, as: :json
    assert_response :unauthorized
  end

  test "should delete" do
    delete watched_task_url(@watched_task), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  private

  def watched_tasks_url
    "/api/v1/watched_tasks"
  end

  def watched_task_url(watched_task)
    "/api/v1/watched_tasks/#{watched_task.id}"
  end
end
