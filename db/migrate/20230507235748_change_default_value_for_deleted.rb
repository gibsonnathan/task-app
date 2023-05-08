class ChangeDefaultValueForDeleted < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tasks, :deleted, false 
    change_column_default :bids, :deleted, false
  end
end
