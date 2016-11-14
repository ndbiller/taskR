class Task < ActiveRecord::Base
  belongs_to :user, counter_cache: :count_of_tasks

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }

  def start
    stop_active_tasks
    update(active: true, started_at: Time.zone.now)
  end

  def stop
    update(active: false,
           stopped_at: Time.zone.now,
           duration: self.duration += (Time.zone.now - started_at).to_i)
  end

  def stop_active_tasks
    Task.where(user_id: user_id, active: true).each(&:stop)
  end
end
