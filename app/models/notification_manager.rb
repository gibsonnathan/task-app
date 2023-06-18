class NotificationManager
  def initialize
  end

  def notify!(users, notification_hash)
    users.collect do |u|
      u.notify! notification_hash
    end
  end
end
