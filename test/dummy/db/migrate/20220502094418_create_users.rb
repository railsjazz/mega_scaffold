class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.date :dob
      t.text :about
      t.string :country

      t.timestamps
    end

    100.times do
      User.create(
        name: "User #{rand(1000)}",
        age: rand(100),
        dob: rand(10000).days.ago,
        about: "Some content goes here",
        country: ["Ukraine", "Poland", "Germany"].sample
      )
    end
  end
end
