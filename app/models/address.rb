class Address < ApplicationRecord
  belongs_to :user
  validates :city, :state, :details, :zipcode, presence: true
  validates :zipcode, format: { with: /(^\d{8}$)|(^\d{5}-\d{3}$)/, message: 'must be the format 12345600 or 12345-600'}
  validates :details, length: { maximum: 40 }
end
