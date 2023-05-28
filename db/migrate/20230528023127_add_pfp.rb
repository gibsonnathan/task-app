class AddPfp < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :pfp_link, :string
  end
end
