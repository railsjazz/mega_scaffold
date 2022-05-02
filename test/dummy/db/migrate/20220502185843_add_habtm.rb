class AddHabtm < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts_categories, id: false do |t|
      t.integer :account_id
      t.integer :category_id
    end
  end
end
