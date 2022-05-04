class Account < ApplicationRecord
  TYPES = ["bussines", "personal", "corporate"]

  belongs_to :owner, class_name: "User"

  has_and_belongs_to_many :categories

  scope :by_name, -> { order(name: :asc) }

  validates :name, presence: true
  validate :name_is_not_include_5

  private

  def name_is_not_include_5
    errors.add(:name, "can't include 5 in name") if name.to_s =~ /5/
  end
end
