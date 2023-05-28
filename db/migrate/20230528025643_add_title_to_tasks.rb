class AddTitleToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :title, :string, null: false
  end
end
