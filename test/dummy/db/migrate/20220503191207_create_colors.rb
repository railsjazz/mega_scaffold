class CreateColors < ActiveRecord::Migration[7.0]
  def change
    create_table :colors do |t|
      t.string :name

      t.timestamps
    end

    create_table :colors_users, id: false do |t|
      t.integer :color_id
      t.integer :user_id
    end

    Color.create(name: 'Black')
    Color.create(name: 'Red')
    Color.create(name: 'Green')
    Color.create(name: 'Yellow')
    Color.create(name: 'Orange')
  end
end
