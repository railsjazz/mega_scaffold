class User < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }
  scope :by_name, -> { order(name: :asc) }
end
