require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid' do
    it 'presence of registration number' do
      user = build(:user, registration_number: '')
      expect(user).not_to be_valid
    end

    it 'presence of address' do
      user = build(:user, address: nil)
      expect(user).not_to be_valid
    end

    it 'presence of email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'presence of password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'format of registration number' do
      user = build(:user, registration_number: '114.444.777.987')
      expect(user).not_to be_valid
    end

    it 'uniqueness of registration number' do
      create(:user)
      user = build(:user)
      expect(user).not_to be_valid
    end
  end
end
