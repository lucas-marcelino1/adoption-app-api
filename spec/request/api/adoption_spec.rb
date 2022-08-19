require 'rails_helper'

RSpec.describe 'Adoption', :type => :request do
  context 'GET api/v1/adoptions' do
    it 'successfully' do
      adoption = create(:adoption)
      animal = Animal.create!(name: 'Alfredo', age: '1.0', specie: 'Dog', gender: 'Male', size: 'Large', user: adoption.user)
      adoption_two = Adoption.create!(title: 'Guard dog', description: 'Perfect dog to protect your home and family.', user: adoption.user, animal: animal)
      

      get('/api/v1/adoptions', headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.first['title']).to eq('This cute cat needs a home')
      expect(json_response.first['description']).to eq("I've founded it on side of Beahaus street inside a box.")
      expect(json_response.first['user']).to eq('User Name')
      expect(json_response.first['location']).to eq('Blumenau || Santa Catarina')
      expect(json_response.last['title']).to eq('Guard dog')
      expect(json_response.last['description']).to eq("Perfect dog to protect your home and family.")
      expect(json_response.last['user']).to eq('User Name')
      expect(json_response.last['location']).to eq('Blumenau || Santa Catarina')

    end
  end
end