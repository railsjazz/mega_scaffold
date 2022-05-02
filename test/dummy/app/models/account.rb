class Account < ApplicationRecord
  belongs_to :owner, class_name: "User"

  validates :name, presence: true
  validate :name_is_not_include_5

  private

  def name_is_not_include_5
    errors.add(:name, "can't include 5 in name") if name.to_s =~ /5/
  end
end
