class Adoption < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :animal

  validates :title, length: { maximum: 40}
  validates :title, :description, presence: true

  # Scopes
  scope :adopted, -> { joins(:animal).where("animals.status = ?", Animal.statuses["in_adoption"]) }

  scope :by_specie, -> (specie) { joins(:animal).where("animals.specie = ?", specie.capitalize) }

  scope :by_city, -> (city) { joins(animal: [{user: :address}]).where("addresses.city = ?", city.capitalize) }

  scope :by_gender, -> (gender) { joins(:animal).where("animals.gender = ?", gender.capitalize) }
end
