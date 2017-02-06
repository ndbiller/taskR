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

  #def to_html_table
  #  html = "<td>#{self.name}</td>
  #          <td>tickets</td>
  #          <td>01:38:41</td>
  #          <td><a class='btn btn-success btn-sm' href='/tasks/5/start'>Start</a></td>
  #          <td><a class='btn btn-danger btn-sm' href='/tasks/5/stop'>Stop</a></td>
  #          <td><a class='btn btn-primary btn-sm' href='/tasks/5/edit'>Edit</a></td>
  #          <td><a data-confirm='Are you sure?' class='btn btn-danger btn-sm' rel='nofollow' data-method='delete' href='/tasks/5'>Remove</a></td>"
  #  html
  #end
end
