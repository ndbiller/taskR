class AddAdvancedToUser < ActiveRecord::Migration
  def change
    add_column :users, :advanced, :bool
  end
end
