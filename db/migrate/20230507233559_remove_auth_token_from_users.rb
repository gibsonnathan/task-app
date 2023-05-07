class RemoveAuthTokenFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :auth_token, :string
  end
end
