require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "bidding on task creates bid" do
    poster = User.create
    bidder = User.create
    t = Task.create({ :user_id => poster.id, :description => "test", :lat => "123", :long => "123", :title => "test", :deleted => false })
    res = t.bid!(bidder, { :amount => 123, :unit => "USD" })
    assert res.persisted?
  end

  test "creating task adds watch" do
    poster = User.create
    t = Task.create({ :user_id => poster.id, :description => "test", :lat => "123", :long => "123", :title => "test", :deleted => false })
    watch = WatchedTask.where(task_id: t.id).where(user_id: poster.id).first
    assert_not_nil watch
  end

  test "bidding on task adds watch" do
    poster = User.create
    bidder = User.create
    t = Task.create({ :user_id => poster.id, :description => "test", :lat => "123", :long => "123", :title => "test", :deleted => false })
    t.bid!(bidder, { :amount => 123, :unit => "USD" })
    watch = WatchedTask.where(task_id: t.id).where(user_id: bidder.id).first
    assert_not_nil watch
  end

  test "watching a task" do
    u = User.create
    u2 = User.create
    t = Task.create({ :user_id => u.id, :description => "test", :lat => "123", :long => "123", :title => "test", :deleted => false })
    wt = t.watch! u2
    assert_equal t.id, wt.task_id
    assert_equal u2.id, wt.user_id
    assert wt.persisted?
  end

  test "getting watchers" do
    u = User.create
    u2 = User.create
    u3 = User.create
    t = Task.create({ :user_id => u.id, :description => "test", :lat => "123", :long => "123", :title => "test", :deleted => false })
    t.watch! u2
    t.watch! u3
    watchers = t.watchers
    assert_equal 3, watchers.size
  end
end
