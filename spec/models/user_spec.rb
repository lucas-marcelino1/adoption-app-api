require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid' do
    it 'presence of registration number' do
      user = User.create(name: 'user', email: 'user@email.com', password: '123456', registration_number:'')
      result = user.valid?
      expect(result).to be false
    end

    it 'format of registration number' do
      user = User.create(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.554.544.44')
      result = user.valid?
      expect(result).to be false
    end

    it 'uniqueness of registration number' do
      User.create(name: 'user', email: 'user@email.com', password: '123456', registration_number:'111.554.544-44')
      user = User.create(name: 'user2', email: 'user2@email.com', password: '123456', registration_number:'111.554.544-44')
      result = user.valid?
      expect(result).to be false
    end
  end
end
