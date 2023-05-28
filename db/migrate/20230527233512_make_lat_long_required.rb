class MakeLatLongRequired < ActiveRecord::Migration[7.0]
  def change
    change_column :tasks, :lat, :float, :null => false
    change_column :tasks, :long, :float, :null => false
  end
end
