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
      expect(json_response.first['animal']['gender']).to eq('Male')
      expect(json_response.first['animal']['specie']).to eq('Cat')
      expect(json_response.last['title']).to eq('Guard dog')
      expect(json_response.last['description']).to eq("Perfect dog to protect your home and family.")
      expect(json_response.last['animal']['gender']).to eq('Male')
      expect(json_response.last['animal']['specie']).to eq('Dog')

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

  context 'GET api/v1/adoptions/adoption_id' do
    it 'successfully' do
      adoption = create(:adoption)

      get("/api/v1/adoptions/#{adoption.id}", headers: adoption.user.create_new_auth_token)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq('This cute cat needs a home')
      expect(json_response['description']).to eq("I've founded it on side of Beahaus street inside a box.")
      expect(json_response['location']).to eq("Blumenau || Santa Catarina")
      expect(json_response['user']).to eq("User Name")
      expect(json_response['animal']['name']).to eq('Tunico')
      expect(json_response['animal']['age']).to eq(0.11)
      expect(json_response['animal']['gender']).to eq('Male')
      expect(json_response['animal']['specie']).to eq('Cat')
      expect(json_response['animal']['size']).to eq('Small')
    end

    it 'without authentication headers and failed' do
      adoption = create(:adoption)
    
      get("/api/v1/adoptions/#{adoption.id}")

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]).to include("You need to sign in or sign up before continuing.")
    end
  end

  context 'POST api/v1/adoptions/adoption_id/adopt' do
    it 'successfully' do
      adoption = create(:adoption)
      user = User.create!(name: 'User Name 2', email: 'user2@email.com', password: '123456', registration_number: '112.221.222-47', confirmed_at: Time.zone.now, address: build(:address))
      adopt_params = { adoption_id: adoption.id, user_email: "user2@email.com" }

      post("/api/v1/adoptions/#{adoption.id}/adopt", headers: adoption.user.create_new_auth_token, params: adopt_params)
      
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Animal adopted successfully.')
    end
  end
end
