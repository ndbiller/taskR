class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.references :user, index: true, foreign_key: true
      t.boolean :active
      t.time :duration
      t.datetime :created_at
      t.datetime :started_at
      t.datetime :stopped_at

      t.timestamps null: false
    end
  end
end
