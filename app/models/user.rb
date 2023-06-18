class User < ApplicationRecord
  has_many :notifications

  def notify!(notification_hash)
    notification = Notification.new(notification_hash.merge({ :read => false, :user_id => id }))
    notification.save
    notification
  end
end
