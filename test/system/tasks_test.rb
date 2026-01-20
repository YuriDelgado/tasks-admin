require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @task = tasks(:one)
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Tasks"
  end

  test "should create task" do
    visit tasks_url
    click_on "New task"

    fill_in "Activity", with: @task.activity_id
    fill_in "Completed at", with: @task.completed_at
    fill_in "Due to", with: @task.due_to
    fill_in "Status", with: @task.status
    click_on "Create Task"

    assert_text "Task was successfully created"
    click_on "Back"
  end

  test "should update Task" do
    visit task_url(@task)
    click_on "Edit this task", match: :first

    fill_in "Activity", with: @task.activity_id
    fill_in "Completed at", with: @task.completed_at.to_s
    fill_in "Due to", with: @task.due_to.to_s
    fill_in "Status", with: @task.status
    click_on "Update Task"

    assert_text "Task was successfully updated"
    click_on "Back"
  end

  test "should destroy Task" do
    visit task_url(@task)
    accept_confirm { click_on "Destroy this task", match: :first }

    assert_text "Task was successfully destroyed"
  end
end
