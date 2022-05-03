class User < ApplicationRecord
  has_many :photos
  has_many :accounts, foreign_key: :owner_id

  scope :ordered, -> { order(id: :desc) }
  scope :by_name, -> { order(name: :asc) }

  validates :name, presence: true
end
