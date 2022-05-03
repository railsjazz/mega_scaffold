class User < ApplicationRecord
  has_many :photos
  has_many :accounts, foreign_key: :owner_id
  has_and_belongs_to_many :colors

  scope :ordered, -> { order(id: :desc) }
  scope :by_name, -> { order(name: :asc) }

  validates :name, presence: true
end
