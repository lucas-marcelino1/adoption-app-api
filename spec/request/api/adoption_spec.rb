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

    it 'and none adoptions registred' do
      user = create(:user)

      get('/api/v1/adoptions', headers: user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('None adoptions registred yet.')
    end

    it 'without authentication headers and failed' do
      adoption = create(:adoption)
      animal = Animal.create!(name: 'Alfredo', age: '1.0', specie: 'Dog', gender: 'Male', size: 'Large', user: adoption.user)
      adoption_two = Adoption.create!(title: 'Guard dog', description: 'Perfect dog to protect your home and family.', user: adoption.user, animal: animal)
      
      get("/api/v1/adoptions")

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end

    it 'and something goes wrong' do
      adoption = create(:adoption)
      allow(Adoption).to receive(:all).and_raise(StandardError)

      get('/api/v1/adoptions', headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:internal_server_error)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['errors']['title']).to eq('Something went wrong.')
      expect(json_response['errors']['details']).to eq("Sorry, we encountered unexpected error.")
    end
  end
end
