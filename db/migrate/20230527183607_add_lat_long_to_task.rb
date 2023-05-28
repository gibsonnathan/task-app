class AddLatLongToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :lat, :float
    add_column :tasks, :long, :float
  end
end
