class CreateExportLists < ActiveRecord::Migration[7.0]
  def change
    create_table :export_lists do |t|
      t.string :name
      t.integer :account_id

      t.timestamps
    end
  end
end
