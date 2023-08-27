require "application_system_test_case"

class WatchedTasksTest < ApplicationSystemTestCase
  setup do
    @watched_task = watched_tasks(:one)
  end

  test "visiting the index" do
    visit watched_tasks_url
    assert_selector "h1", text: "Watched tasks"
  end

  test "should create watched task" do
    visit watched_tasks_url
    click_on "New watched task"

    click_on "Create Watched task"

    assert_text "Watched task was successfully created"
    click_on "Back"
  end

  test "should update Watched task" do
    visit watched_task_url(@watched_task)
    click_on "Edit this watched task", match: :first

    click_on "Update Watched task"

    assert_text "Watched task was successfully updated"
    click_on "Back"
  end

  test "should destroy Watched task" do
    visit watched_task_url(@watched_task)
    click_on "Destroy this watched task", match: :first

    assert_text "Watched task was successfully destroyed"
  end
end
