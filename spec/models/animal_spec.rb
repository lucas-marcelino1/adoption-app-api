require 'rails_helper'

RSpec.describe Animal, type: :model do
  describe '#valid?' do
    it 'presence of name' do
      animal = build(:animal, name:'')
      expect(animal).not_to be_valid
    end

    it 'presence of age' do
      animal = build(:animal, age: '')
      expect(animal).not_to be_valid
    end

    it 'presence of specie' do
      animal = build(:animal, specie: '')
      expect(animal).not_to be_valid
    end

    it 'presence of gender' do
      animal = build(:animal, gender: '')
      expect(animal).not_to be_valid
    end

    it 'presence of size' do
      animal = build(:animal, size: '')
      expect(animal).not_to be_valid
    end

    it 'invalid size' do
      animal = build(:animal, size: 'Big') # Needs to be Small, Medium, Large
      expect(animal).not_to be_valid
    end

    it 'invalid gender' do
      animal = build(:animal, gender: 'Grêmio')
      expect(animal).not_to be_valid
    end

    it 'invalid age' do
      animal = build(:animal, age: '-1.1')
      expect(animal).not_to be_valid
    end
  end
end
