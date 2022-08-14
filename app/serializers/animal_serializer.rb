class AnimalSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :specie, :size, :user_id
end
