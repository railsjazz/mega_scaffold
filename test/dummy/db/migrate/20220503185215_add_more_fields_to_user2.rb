class AddMoreFieldsToUser2 < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :facebook_url, :string
    add_column :users, :favorite_color, :string
    add_column :users, :secret_password, :string
  end
end
