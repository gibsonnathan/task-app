require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:task_one)
  end

  test "should get index" do
    get tasks_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  test "should not get index when unauthenticated" do
    get tasks_url, as: :json
    assert_response :unauthorized
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER },
                      params: { task: { "description" => "test",
                                       "lat" => "123.45", "long" => "234.45", "title" => "test title" } }, as: :json
    end

    assert_response :created
  end

  test "creating task with new user should create user" do
    assert_difference("User.count", 1) do
      post tasks_url, headers: { "Authorization" => USER_NOT_IN_DB },
                      params: { task: { "description" => "test", "lat" => "123.45",
                                       "long" => "234.45", "title" => "test title" } }, as: :json
    end

    assert_response :created
  end

  test "should not create task when unauthenticated" do
    post tasks_url, params: { task: {} }, as: :json
    assert_response :unauthorized
  end

  test "should show task" do
    get task_url(@task), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    assert_response :success
  end

  test "should not show task when unauthenticated" do
    get task_url(@task), as: :json
    assert_response :unauthorized
  end

  test "should update task" do
    patch task_url(@task), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, params: { task: {} }, as: :json
    assert_response :success
  end

  test "user two cannot update user one's task" do
    patch task_url(@task), headers: { "Authorization" => USER_TWO_AUTH_HEADER }, params: { task: {} }, as: :json
    assert_response :unauthorized
  end

  test "should soft delete task" do
    assert_difference("Task.count", 0) do
      delete task_url(@task), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    end

    assert_response :no_content
  end

  test "user two cannot delete user one's task" do
    delete task_url(@task), headers: { "Authorization" => USER_TWO_AUTH_HEADER }, as: :json
    assert_response :unauthorized
  end

  private

  def task_url(task)
    "/api/v1/tasks/#{task.id}"
  end

  def tasks_url
    return "/api/v1/tasks/"
  end
end
