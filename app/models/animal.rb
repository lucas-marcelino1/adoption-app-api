class Animal < ApplicationRecord
  belongs_to :user
  validates :name, :age, :specie, :gender, :size, presence: true
  validates :age, numericality: {greater_than: 0} 
  validates :size, inclusion: { in: %w(Small Medium Large),
    message: "%{value} is not a valid size" }
  validates :gender, inclusion: { in: %w(Male Female),
    message: "%{value} is not a valid gender" }
end
