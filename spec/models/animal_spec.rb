require 'rails_helper'

RSpec.describe Animal, type: :model do
  describe '#valid' do
    it 'presence of name' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      animal = Animal.create(name:'', age: '0.11', specie: 'Cat', gender: 'Male', size: 'Small', user: user)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of age' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      animal = Animal.create(name:'Tunico', age: '', specie: 'Cat', gender: 'Male', size: 'Small', user: user)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of specie' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      animal = Animal.create(name:'Tunico', age: '0.11', specie: '', gender: 'Male', size: 'Small', user: user)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of gender' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      animal = Animal.create(name:'Tunico', age: '0.11', specie: 'Cat', gender: '', size: 'Small', user: user)
      result = animal.valid?
      expect(result).to be false
    end

    it 'presence of size' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create!(name: 'User Name', email: 'user@email.com', password: '123456', registration_number: '111.554.544-44', address: address)
      animal = Animal.create(name:'Tunico', age: '0.11', specie: 'Cat', gender: 'Male', size: '', user: user)
      result = animal.valid?
      expect(result).to be false
    end
  end
end
