class Category < ApplicationRecord
  has_and_belongs_to_many :accounts

  scope :by_name, -> { order(:name) }

  validates :name, presence: true
end
