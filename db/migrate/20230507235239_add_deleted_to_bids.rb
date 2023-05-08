class AddDeletedToBids < ActiveRecord::Migration[7.0]
  def change
    add_column :bids, :deleted, :boolean
  end
end
