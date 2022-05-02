class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :company_id

      t.timestamps
    end
  end
end
