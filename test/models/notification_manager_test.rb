require "test_helper"

class NotificationManagerTest < ActiveSupport::TestCase
  test "notify creates a notification" do
    u = User.create
    t = Task.create({ :description => "test", :user_id => u.id, :deleted => false, :lat => 123, :long => 123, :title => "title" })
    nm = NotificationManager.new
    notifications = nm.notify!([u], { :task_id => t.id, :message => "test notification" })
    assert_equal(1, notifications.count)
    assert_equal(u.id, notifications.first.user_id)
    assert_equal(t.id, notifications.first.task_id)
    assert_equal("test notification", notifications.first.message)
  end
end
