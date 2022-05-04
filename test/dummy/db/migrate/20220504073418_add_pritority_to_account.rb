class AddPritorityToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :priority, :integer
  end
end
