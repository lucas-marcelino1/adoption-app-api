class Animal < ApplicationRecord
  belongs_to :user
  validates :name, :age, :specie, :gender, :size, presence: true
end
