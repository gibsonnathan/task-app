class CreateWatchlists < ActiveRecord::Migration[7.0]
  def change
    create_table :watched_tasks do |t|
      t.integer :user_id, null: false
      t.integer :task_id, null: false
      t.timestamps
    end
  end
end
