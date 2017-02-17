class AddCategoriesToUser < ActiveRecord::Migration
  def change
    add_column :users, :categories, :text, array:true, default: ['none']
  end
end
