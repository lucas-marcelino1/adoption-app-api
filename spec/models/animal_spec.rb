require 'rails_helper'

RSpec.describe Animal, type: :model do
  describe '#valid' do
    it 'presence of name' do
      user = User.create!(name: 'user', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44')
      animal = Animal.create(name:'', age: '0.11', specie: 'Cat', gender: 'Male', size: 'Small', user_id: user.id)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of age' do
      user = User.create!(name: 'user', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44')
      animal = Animal.create(name:'Tunico', age: '', specie: 'Cat', gender: 'Male', size: 'Small', user_id: user.id)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of specie' do
      user = User.create!(name: 'user', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44')
      animal = Animal.create(name:'Tunico', age: '0.11', specie: '', gender: 'Male', size: 'Small', user_id: user.id)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of gender' do
      user = User.create!(name: 'user', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44')
      animal = Animal.create(name:'Tunico', age: '0.11', specie: 'Cat', gender: '', size: 'Small', user_id: user.id)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of size' do
      user = User.create!(name: 'user', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44')
      animal = Animal.create(name:'Tunico', age: '0.11', specie: 'Cat', gender: 'Male', size: '', user_id: user.id)
      result = animal.valid?
      expect(result).to be false
    end
  end
end
