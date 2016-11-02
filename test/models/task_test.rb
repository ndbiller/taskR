require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def task
    @task ||= Task.new
  end

  def test_valid
    assert task.valid?
  end
end
