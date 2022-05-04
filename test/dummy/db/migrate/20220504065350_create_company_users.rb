class CreateCompanyUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :company_users do |t|
      t.integer :company_id
      t.integer :user_id

      t.timestamps
    end
  end
end
