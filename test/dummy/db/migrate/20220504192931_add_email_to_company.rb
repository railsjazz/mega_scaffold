class AddEmailToCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :email, :string
  end
end
