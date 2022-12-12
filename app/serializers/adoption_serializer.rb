class AdoptionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :location, :animal_information
  belongs_to :user
  belongs_to :animal

  def user 
    object.user.name
  end

  def animal_information
    "#{object.animal.age} anos - #{object.animal.size}"
  end

  def animal
    "#{object.animal.specie} | #{object.animal.gender}"
  end

  def location
    "#{object.user.address.city} - #{object.user.address.state}"
  end

end
