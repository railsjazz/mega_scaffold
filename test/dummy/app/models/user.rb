class User < ApplicationRecord
  has_many :photos

  scope :ordered, -> { order(id: :desc) }
  scope :by_name, -> { order(name: :asc) }

  validates :name, presence: true
end
