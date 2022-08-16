require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid' do
    it 'presence of registration number' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create(name: 'user', email: 'user@email.com', password: '123456', registration_number:'', address: address)
      result = user.valid?
      expect(result).to be false
    end

    it 'format of registration number' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      user = User.create(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.554.544.44', address: address)
      result = user.valid?
      expect(result).to be false
    end

    it 'uniqueness of registration number' do
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540')
      User.create(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.554.544-44', address: address)
      user = User.create(name: 'user2', email: 'user2@email.com', password: '123456', registration_number:'111.554.544-44', address: address)
      result = user.valid?
      expect(result).to be false
    end
  end
end
