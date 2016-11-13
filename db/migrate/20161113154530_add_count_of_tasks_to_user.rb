class AddCountOfTasksToUser < ActiveRecord::Migration
  def change
    add_column :users, :count_of_tasks, :int
  end
end
