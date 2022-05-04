class Company < ApplicationRecord
  has_many :attachments, dependent: :destroy
  has_many :company_users
  has_many :user, through: :company_users

  validates :name, presence: true
end
