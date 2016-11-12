class Task < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 255 }
  validates :name, presence: true

  def start
    self.update(active: true, started_at: Time.zone.now)
  end

  def stop
    self.update(active: false, stopped_at: Time.zone.now, duration: self.duration += (Time.zone.now - self.started_at))
  end
end
