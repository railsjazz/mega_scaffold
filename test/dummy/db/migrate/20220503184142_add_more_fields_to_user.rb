class AddMoreFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :expected_salary, :bigint
    add_column :users, :avg_salary, :float
    add_column :users, :hireable, :boolean, default: false
  end
end
