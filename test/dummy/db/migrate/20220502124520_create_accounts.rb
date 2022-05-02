class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :owner_id

      t.timestamps
    end

    100.times do
      Account.create(
        name: Faker::Company.name,
        owner: User.all.sample
      )
    end
  end
end
