class AddDeletedToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :deleted, :boolean
  end
end
