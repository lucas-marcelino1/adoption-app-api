class Adoption < ApplicationRecord
  belongs_to :user
  belongs_to :animal

  validates :title, length: { maximum: 40}
  validates :title, :description, presence: true
end
