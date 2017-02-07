class AddStartOfTrainingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :start_of_training, :date
  end
end
