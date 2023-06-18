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

  test "getting all tasks" do
    get tasks_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    res = JSON.parse response.body
    assert_equal 2, res.length
  end

  test "getting a task" do
    get task_url(@task), headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    res = JSON.parse response.body
    assert_not_nil res["description"]
    assert_not_nil res["deleted"]
    assert_not_nil res["user_id"]
    assert_not_nil res["lat"]
    assert_not_nil res["long"]
    assert_not_nil res["title"]
  end

  test "creating a task" do
    Bid.delete_all
    Notification.delete_all
    WatchedTask.delete_all
    Task.delete_all
    assert_empty Task.all
    post tasks_url, headers: { "Authorization" => USER_ONE_AUTH_HEADER },
    params: { task: { "description" => "test",
                     "lat" => "123.45", "long" => "234.45", "title" => "test title" } }, as: :json
    assert_equal 1, Task.all.length
    task = Task.first
    assert_equal "test", task.description
    assert_equal 123.45, task.lat
    assert_equal 234.45, task.long
    assert_equal "test title", task.title
  end

  test "getting a task within radius" do
    get "#{tasks_url}?lat=34&long=84&radius=100", headers: { "Authorization" => USER_ONE_AUTH_HEADER }, as: :json
    body = JSON.parse response.body
    assert_equal 1, body.length
    res = body.first
    assert_not_nil res["description"]
    assert_not_nil res["deleted"]
    assert_not_nil res["user_id"]
    assert_not_nil res["lat"]
    assert_not_nil res["long"]
    assert_not_nil res["title"]
  end

  private

  def task_url(task)
    "/api/v1/tasks/#{task.id}"
  end

  def tasks_url
    return "/api/v1/tasks/"
  end
end
