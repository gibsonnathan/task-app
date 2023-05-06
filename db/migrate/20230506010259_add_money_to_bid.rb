class AddMoneyToBid < ActiveRecord::Migration[7.0]
  def change
    add_column :bids, :amount, :integer
    add_column :bids, :unit, :string
  end
end
