class AnimalSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :specie, :size

  belongs_to :user
end
