require 'rails_helper'

RSpec.describe Adoption, type: :model do
  describe '#valid?' do
    it 'presence of title' do
      adoption = build(:adoption, title: '')
      expect(adoption).not_to be_valid
    end

    it 'presence of description' do
      adoption = build(:adoption, description: '')
      expect(adoption).not_to be_valid
    end

    it 'length of title' do
      adoption = build(:adoption, title: 'DIUWAHUHIWDAUHWIDAWDHUIADWUHWWUHDWADWAWDADW')
      expect(adoption).not_to be_valid
    end
  end
end
