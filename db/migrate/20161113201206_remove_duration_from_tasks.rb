class RemoveDurationFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :duration
  end
end
