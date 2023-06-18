class Task < ApplicationRecord
  belongs_to :user

  after_initialize do |t|
    @notification_manager = NotificationManager.new
  end

  after_create do |t|
    watch! t.user
  end

  def distance_to(other_lat, other_long)
    Haversine.distance(lat, long, other_lat, other_long).to_miles
  end

  def in_radius?(other_lat, other_long, radius)
    distance_to(other_lat, other_long) <= radius
  end

  def bid!(user, bid_hash)
    bid = Bid.new(bid_hash.merge({ :user_id => user.id, :task_id => id, :deleted => false }))
    res = bid.save
    watch!(user)
    if res
      @notification_manager.notify!(watchers, { :task_id => id, :message => "#{user.first_name} placed a bid on \"#{title}\"." })
    end
    bid
  end

  def watch!(user)
    if WatchedTask.where(task_id: id).where(user_id: user.id).none?
      wt = WatchedTask.create({ :task_id => id, :user_id => user.id })
      wt.save
      wt
    end
  end

  def watchers
    WatchedTask.where(task_id: id).map(&:user)
  end
end
