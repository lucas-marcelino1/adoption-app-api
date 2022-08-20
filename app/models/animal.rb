class Animal < ApplicationRecord
  belongs_to :user
  has_one :adoption
  validates :name, :age, :specie, :gender, :size, presence: true
  validates :age, numericality: {greater_than: 0} 
  validates :size, inclusion: { in: %w(Small Medium Large),
    message: "%{value} is not a valid size" }
  validates :gender, inclusion: { in: %w(Male Female),
    message: "%{value} is not a valid gender" }
  enum status: {unpublished: 0, in_adoption: 2, adopted: 4}
end
