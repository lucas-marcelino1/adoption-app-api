class AddressSerializer < ActiveModel::Serializer
  attributes :city, :state, :details, :zipcode
end
