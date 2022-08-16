require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid?' do
    it 'presence of city' do
      user = User.new(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.444.777-98')
      address = Address.new(city: '', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540', user: user)
      result = address.valid?
      expect(result).to be false
    end

    it 'presence of state' do
      user = User.new(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.444.777-98')
      address = Address.new(city: 'Blumenau', state: '', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 540', user: user)
      result = address.valid?
      expect(result).to be false
    end

    it 'presence of zipcode' do
      user = User.new(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.444.777-98')
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '', details: 'Rua Dr. Antonio Hafner, 540', user: user)
      result = address.valid?
      expect(result).to be false
    end

    it 'presence of details' do
      user = User.new(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.444.777-98')
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: '', user: user)
      result = address.valid?
      expect(result).to be false
    end

    it 'format of zipcode' do
      user = User.new(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.444.777-98')
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-4444', details: 'Rua Dr. Antonio Hafner, 540', user: user)
      result = address.valid?
      expect(result).to be false
    end

    it 'length of details' do
      user = User.new(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.444.777-98')
      address = Address.new(city: 'Blumenau', state: 'Santa Catarina', zipcode: '89026-444', details: 'Rua Dr. Antonio Hafner, 5400000000000000000000000', user: user)
      result = address.valid?
      expect(result).to be false
    end
  end
end
