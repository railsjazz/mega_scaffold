class Category < ApplicationRecord
  scope :by_name, -> { order(:name) }

  validates :name, presence: true
end
