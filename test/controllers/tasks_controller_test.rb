require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:task_one)
  end

  test "should get index" do
    get tasks_url, headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    assert_response :success
  end

  test "should create task" do
    assert_difference("Task.count") do
      post tasks_url, headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, params: { task: {} }, as: :json
    end

    assert_response :created
  end

  test "should show task" do
    get task_url(@task), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    assert_response :success
  end

  test "should update task" do
    patch task_url(@task), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, params: { task: {} }, as: :json
    assert_response :success
  end

  test "should soft delete task" do
    assert_difference("Task.count", 0) do
      delete task_url(@task), headers: { "Authorization" => TEST_AUTHORIZATION_HEADER }, as: :json
    end

    assert_response :no_content
  end

  private

  def task_url(task)
    "/api/v1/tasks/#{task.id}"
  end

  def tasks_url
    return "/api/v1/tasks/"
  end
end
