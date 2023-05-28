class Task < ApplicationRecord
  belongs_to :user

  def distance_to(other_lat, other_long)
    Haversine.distance(lat, long, other_lat, other_long).to_miles
  end

  def in_radius?(other_lat, other_long, radius)
    distance_to(other_lat, other_long) <= radius
  end
end
