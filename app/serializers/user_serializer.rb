class UserSerializer < ActiveModel::Serializer
  attributes :email, :name

  has_one :address
end
