class AnimalSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :specie, :size
end
