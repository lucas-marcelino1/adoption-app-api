class AdoptionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location
  belongs_to :user
  belongs_to :animal

  def user 
    object.user.name
  end

  def location
    "#{object.user.address.city} || #{object.user.address.state}"
  end

end
