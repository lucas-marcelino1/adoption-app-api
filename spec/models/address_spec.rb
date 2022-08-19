require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid?' do
    it 'presence of city' do
      address = build(:address, city: '')
      expect(address).not_to be_valid
    end

    it 'presence of state' do
      address = build(:address, state: '')
      expect(address).not_to be_valid
    end

    it 'presence of zipcode' do
      address = build(:address, zipcode: '')
      expect(address).not_to be_valid
    end

    it 'presence of details' do
      address = build(:address, details: '')
      expect(address).not_to be_valid
    end

    it 'format of zipcode' do
      address = build(:address, zipcode: '1447-4474')
      expect(address).not_to be_valid
    end

    it 'length of details' do
      address = build(:address, details: 'Rua Dr. Antônio Haffner, 540 AAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
      expect(address).not_to be_valid
    end
  end
end
