require "test_helper"

class WatchedTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @watched_task = watched_tasks(:watched_task_one)
  end

  test "should get index" do
    get watched_tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_watched_task_url
    assert_response :success
  end

  test "should create watched_task" do
    assert_difference("WatchedTask.count") do
      post watched_tasks_url, params: { watched_task: {  } }
    end

    assert_redirected_to watched_task_url(WatchedTask.last)
  end

  test "should show watched_task" do
    get watched_task_url(@watched_task)
    assert_response :success
  end

  test "should get edit" do
    get edit_watched_task_url(@watched_task)
    assert_response :success
  end

  test "should update watched_task" do
    patch watched_task_url(@watched_task), params: { watched_task: {  } }
    assert_redirected_to watched_task_url(@watched_task)
  end

end
