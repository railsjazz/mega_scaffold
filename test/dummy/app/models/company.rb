class Company < ApplicationRecord
  has_many :attachments, dependent: :destroy

  validates :name, presence: true
end
